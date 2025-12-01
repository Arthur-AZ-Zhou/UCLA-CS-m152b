import numpy as np
import os

# Paths
MODEL_PATH = "mnist_model.npz"
# Path relative to where the script is run (in model_training dir)
OUTPUT_DIR = "../FinalProject.srcs/sources_1/new/"

def generate_mem_files():
    if not os.path.exists(MODEL_PATH):
        print(f"Error: {MODEL_PATH} not found. Please run train_model.ipynb first.")
        return

    print(f"Loading model from {MODEL_PATH}...")
    data = np.load(MODEL_PATH)
    w1 = data['w1']  # Shape (128, 784)
    w2 = data['w2']  # Shape (10, 128)
    
    # Check shapes
    assert w1.shape == (128, 784), f"Unexpected W1 shape: {w1.shape}"
    assert w2.shape == (10, 128), f"Unexpected W2 shape: {w2.shape}"
    
    # Ensure output dir exists
    if not os.path.exists(OUTPUT_DIR):
        print(f"Warning: Output directory {OUTPUT_DIR} does not exist. Creating it...")
        os.makedirs(OUTPUT_DIR)

    print("Generating .mem files...")
    
    # ---------------------------------------------------------
    # 1. Layer 1 Weights (Wide)
    # Target: 512 bits (64 bytes) per line
    # Batch 0: Neurons 0-63
    # Batch 1: Neurons 64-127
    # ---------------------------------------------------------
    with open(os.path.join(OUTPUT_DIR, "weights_l1_wide.mem"), "w") as f:
        # Loop over batches
        for batch_idx in range(2): # 0, 1
            start_neuron = batch_idx * 64
            end_neuron = start_neuron + 64
            
            # Loop over pixels (columns)
            for pixel_idx in range(784):
                # Get the 64 weights for this pixel across the 64 neurons
                # Slice: w1[start:end, pixel]
                weights_slice = w1[start_neuron:end_neuron, pixel_idx]
                
                # Convert to hex string
                # We want Neuron (end-1) at MSB ... Neuron start at LSB
                # Example: If batch is 0-63, we write Neuron 63 first (leftmost char)
                
                hex_line = ""
                # Iterate backwards from (64-1) down to 0
                for n in range(63, -1, -1):
                    val = weights_slice[n]
                    # Convert signed int8 to 2-char hex (handles negative numbers correctly)
                    # Python's hex() or format with 02X handles unsigned interpretation, 
                    # so we mask with 0xFF.
                    hex_val = f"{val & 0xFF:02X}"
                    hex_line += hex_val
                
                f.write(hex_line + "\n")
    
    print(f"Written weights_l1_wide.mem to {OUTPUT_DIR}")

    # ---------------------------------------------------------
    # 2. Layer 2 Weights (Wide-ish)
    # Target: 80 bits (10 bytes) per line
    # One line per input (0 to 127)
    # ---------------------------------------------------------
    with open(os.path.join(OUTPUT_DIR, "weights_l2_wide.mem"), "w") as f:
        for input_idx in range(128):
            # Get weights for all 10 output neurons for this input
            # w2[:, input_idx]
            weights_slice = w2[:, input_idx] # Shape (10,)
            
            # Neuron 9 is MSB ... Neuron 0 is LSB
            hex_line = ""
            for n in range(9, -1, -1):
                val = weights_slice[n]
                hex_val = f"{val & 0xFF:02X}"
                hex_line += hex_val
            
            f.write(hex_line + "\n")
            
    print(f"Written weights_l2_wide.mem to {OUTPUT_DIR}")
    
    # ---------------------------------------------------------
    # 3. Dummy Biases
    # ---------------------------------------------------------
    # Layer 1 Biases: 128 lines of 32-bit zeros (8 hex chars)
    with open(os.path.join(OUTPUT_DIR, "biases_l1.mem"), "w") as f:
        for _ in range(128):
            f.write("00000000\n")
            
    # Layer 2 Biases: 10 lines of 32-bit zeros
    with open(os.path.join(OUTPUT_DIR, "biases_l2.mem"), "w") as f:
        for _ in range(10):
            f.write("00000000\n")
            
    print("Written dummy bias files.")
    print("Done!")

if __name__ == "__main__":
    generate_mem_files()


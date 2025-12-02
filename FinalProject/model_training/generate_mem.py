import numpy as np
import os

# Configuration
MODEL_PATH = "mnist_model.npz"
OUTPUT_DIR = "../FinalProject.srcs/sources_1/new/"  # Saves to current directory

def to_hex(val, bits=8):
    """Converts an integer to a hex string of specific bit width."""
    # FIX: Explicitly cast numpy types to Python int to avoid OverflowError
    # when applying bitmasks (e.g. 255 doesn't fit in int8).
    val = int(val) 
    mask = (1 << bits) - 1
    return f"{val & mask:02X}"

def generate_mem_files():
    if not os.path.exists(MODEL_PATH):
        print(f"Error: {MODEL_PATH} not found. Please train the model first.")
        return

    print(f"Loading model from {MODEL_PATH}...")
    data = np.load(MODEL_PATH)
    w1 = data['w1']          # Shape (128, 784)
    w2 = data['w2']          # Shape (10, 128)
    shift_l1 = int(data['shift_l1'])
    shift_l2 = int(data['shift_l2'])

    # Validate Shapes
    print(f"W1 Shape: {w1.shape} (Expected: 128, 784)")
    print(f"W2 Shape: {w2.shape} (Expected: 10, 128)")
    print(f"Shift L1: {shift_l1}")
    print(f"Shift L2: {shift_l2}")

    # Ensure output directory exists
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # =========================================================
    # 1. Generate Layer 1 Weights (weights_l1.mem)
    # Architecture: 64 Parallel DSPs
    # Layout: 1568 lines total
    #   - Lines 0-783:    Neurons 0-63 (Batch 0)
    #   - Lines 784-1567: Neurons 64-127 (Batch 1)
    # Each line contains 64 bytes (Weights for N63...N0 for a specific pixel)
    # =========================================================
    w1_filename = os.path.join(OUTPUT_DIR, "weights_l1.mem")
    print(f"Generating {w1_filename}...")
    
    with open(w1_filename, "w") as f:
        # Iterate over Batches (0 and 1)
        for batch in range(2):
            start_neuron = batch * 64
            end_neuron = start_neuron + 64
            
            # Iterate over Pixels (Inputs)
            for pixel_idx in range(784):
                # Get 64 weights for this pixel
                weights_slice = w1[start_neuron:end_neuron, pixel_idx]
                
                # Build Hex String (MSB = Last Neuron, LSB = First Neuron)
                # We iterate backwards so Neuron 63 is at the "left" (MSB) of the hex string
                hex_line = ""
                for n in reversed(range(64)):
                    hex_line += to_hex(weights_slice[n])
                
                f.write(hex_line + "\n")

    # =========================================================
    # 2. Generate Layer 2 Weights (weights_l2.mem)
    # Architecture: 10 Parallel DSPs (subset of the 64)
    # Layout: 128 lines total (one per hidden layer input)
    # Each line contains 10 bytes (Weights for Output 9...0)
    # =========================================================
    w2_filename = os.path.join(OUTPUT_DIR, "weights_l2.mem")
    print(f"Generating {w2_filename}...")
    
    with open(w2_filename, "w") as f:
        # Iterate over Hidden Layer Inputs
        for input_idx in range(128):
            # Get weights for all 10 outputs
            weights_slice = w2[:, input_idx]
            
            hex_line = ""
            for n in reversed(range(10)):
                hex_line += to_hex(weights_slice[n])
            
            f.write(hex_line + "\n")

    # =========================================================
    # 3. Generate Shift Parameters (shifts.mem)
    # Stores the quantization shift values.
    # Line 0: Shift L1
    # Line 1: Shift L2
    # =========================================================
    shift_filename = os.path.join(OUTPUT_DIR, "shifts.mem")
    print(f"Generating {shift_filename}...")
    
    with open(shift_filename, "w") as f:
        # Write as 8-bit hex values
        f.write(to_hex(shift_l1) + "\n")
        f.write(to_hex(shift_l2) + "\n")

    print("Done! Memory files generated successfully.")

if __name__ == "__main__":
    generate_mem_files()
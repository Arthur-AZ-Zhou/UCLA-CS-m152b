// AXI GPIO driver
#include "xgpio.h"

// UART I/O drivers
#include "xuartlite.h"

// UART output
#include "xil_printf.h"

// Parameters
#include "xparameters.h"

// Add delay function
#include "sleep.h"

// Function to scan keypad (returns button number 0-15, or -1 if none pressed)
int scan_keypad(XGpio *kypd_gpio)
{
    u32 col_mask, row_value;
    int row, col;

    // Scan each column (drive column LOW, others HIGH)
    for (col = 0; col < 4; col++)
    {
        // Drive current column LOW, others HIGH
        // Assuming columns are bits 0-3 of channel 1
        col_mask = 0x0F & ~(1 << col);  // Set column bit to 0, others to 1
        XGpio_DiscreteWrite(kypd_gpio, 1, col_mask);

        // Small delay for signal stabilization
        usleep(1000);  // 1ms

        // Read rows (assuming rows are bits 4-7 of channel 1, or separate channel)
        // Adjust based on your IP configuration
        row_value = XGpio_DiscreteRead(kypd_gpio, 2);  // Read from channel 2

        // Check which row is LOW (button pressed)
        for (row = 0; row < 4; row++)
        {
            if (!(row_value & (1 << row)))  // Row is LOW = button pressed
            {
                return (row * 4 + col);  // Return button number 0-15
            }
        }
    }

    return -1;  // No button pressed
}

// Function to determine winner
// 0=rock, 1=paper, 2=scissors
void determine_winner(int pc_choice, int fpga_choice)
{
    const char *choices[] = {"rock", "paper", "scissors"};

    if (pc_choice == fpga_choice)
    {
        xil_printf("Tie! Both chose %s\r\n", choices[pc_choice]);
    }
    else if ((pc_choice == 0 && fpga_choice == 2) ||  // rock beats scissors
             (pc_choice == 1 && fpga_choice == 0) ||  // paper beats rock
             (pc_choice == 2 && fpga_choice == 1))    // scissors beats paper
    {
        xil_printf("PC won! %s > %s\r\n", choices[pc_choice], choices[fpga_choice]);
    }
    else
    {
        xil_printf("FPGA won! %s > %s\r\n", choices[fpga_choice], choices[pc_choice]);
    }
}

int main()
{
    XGpio gpio_led;
    XGpio gpio_kypd;
    XUartLite uart;
    char ch;
    int pc_choice = -1;
    int fpga_choice = -1;
    int keypad_button;
    int last_button = -1;  // Debouncing

    // Initialize LED GPIO (device ID 0)
    XGpio_Initialize(&gpio_led, 0);
    XGpio_SetDataDirection(&gpio_led, 2, 0x00000000);
    XGpio_DiscreteWrite(&gpio_led, 2, 0x00000000);

    // Initialize Keypad GPIO (device ID 1 - adjust based on your design)
    XGpio_Initialize(&gpio_kypd, 1);
    // Set columns as outputs (channel 1, bits 0-3)
    XGpio_SetDataDirection(&gpio_kypd, 1, 0xFFFFFFF0);
    // Set rows as inputs (channel 2, bits 0-3)
    XGpio_SetDataDirection(&gpio_kypd, 2, 0xFFFFFFFF);

    // Initialize UART
    XUartLite_Initialize(&uart, XPAR_UARTLITE_0_DEVICE_ID);

    xil_printf("\r\n=== Rock-Paper-Scissors Game ===\r\n");
    xil_printf("PC: Enter 0=rock, 1=paper, 2=scissors\r\n");
    xil_printf("FPGA: Press keypad button 0, 1, or 2\r\n");
    xil_printf("Waiting for PC choice...\r\n");

    while (1)
    {
        // Check for PC input via UART
        if (pc_choice == -1 && XUartLite_Recv(&uart, (u8 *)&ch, 1) == 1)
        {
            if (ch >= '0' && ch <= '2')
            {
                pc_choice = ch - '0';
                xil_printf("PC chose %d. Waiting for FPGA choice...\r\n", pc_choice);
            }
        }

        // Check for keypad input
        if (fpga_choice == -1)
        {
            keypad_button = scan_keypad(&gpio_kypd);

            // Debouncing: only register new press
            if (keypad_button != last_button)
            {
                last_button = keypad_button;

                if (keypad_button >= 0 && keypad_button <= 2)
                {
                    fpga_choice = keypad_button;
                    xil_printf("FPGA chose %d.\r\n", fpga_choice);
                }
            }
        }

        // Both players made their choice
        if (pc_choice != -1 && fpga_choice != -1)
        {
            determine_winner(pc_choice, fpga_choice);

            // Reset for next round
            pc_choice = -1;
            fpga_choice = -1;
            last_button = -1;

            xil_printf("\r\n--- Next Round ---\r\n");
            xil_printf("Waiting for PC choice...\r\n");
        }

        usleep(10000);  // 10ms delay between scans
    }

    return 0;
}
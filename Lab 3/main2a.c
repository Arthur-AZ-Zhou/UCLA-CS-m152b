// AXI GPIO driver
#include "xgpio.h"

// UART I/O drivers
#include "xuartlite.h"

// UART output
#include "xil_printf.h"

// Parameters
#include "xparameters.h"

int main()
{
    XGpio gpio;
    XUartLite uart;
    int num1 = 0, num2 = 0;
    char ch;
    int state = 0;  // 0: collecting num1, 1: collecting num2 (after /)
    int product;
    u32 led_value;

    // Initialize GPIO (device ID 0 as in reference code)
    XGpio_Initialize(&gpio, 0);

    // Set LED GPIO channel 2 to All Output (matching reference code)
    XGpio_SetDataDirection(&gpio, 2, 0x00000000);

    // Turn off all LEDs initially
    XGpio_DiscreteWrite(&gpio, 2, 0x00000000);

    // Initialize UART
    XUartLite_Initialize(&uart, XPAR_UARTLITE_0_DEVICE_ID);

    xil_printf("Enter num1/num2: \r\n");

    while (1)
    {
        // Read one byte from UART
        if (XUartLite_Recv(&uart, (u8 *)&ch, 1) == 1)
        {
            // Process newline - calculate and output result
            if (ch == '\r' || ch == '\n')
            {
                if (state == 1 && num2 > 0)  // Valid input received
                {
                    product = num1 * num2;
                    xil_printf("Product: %d\r\n", product);

                    // LED on if product > 100 - write to channel 2
                    if (product > 100)
                        led_value = 0x00000001;  // All LEDs on
                    else
                        led_value = 0x00000000;  // All LEDs off

                    XGpio_DiscreteWrite(&gpio, 2, led_value);

                    // Reset for next input
                    num1 = num2 = 0;
                    state = 0;
                    xil_printf("Enter num1/num2: \r\n");
                }
                continue;  // Ignore extra newlines
            }

            // State 0: Collecting digits for num1
            if (state == 0)
            {
                if (ch >= '0' && ch <= '9')
                {
                    // Accumulate digit into num1
                    num1 = num1 * 10 + (ch - '0');
                }
                else if (ch == '/')
                {
                    // Transition to collecting num2
                    state = 1;
                }
                else
                {
                    // Invalid character
                    xil_printf("Invalid char. Reset.\r\n");
                    num1 = num2 = 0;
                    state = 0;
                }
            }
            // State 1: Collecting digits for num2 (after /)
            else if (state == 1)
            {
                if (ch >= '0' && ch <= '9')
                {
                    // Accumulate digit into num2
                    num2 = num2 * 10 + (ch - '0');
                }
                else
                {
                    // Invalid character after /
                    xil_printf("Invalid char. Reset.\r\n");
                    num1 = num2 = 0;
                    state = 0;
                }
            }
        }
    }

    return 0;
}
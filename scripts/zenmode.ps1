# Load the System.Windows.Forms assembly for accessing screen properties
Add-Type -AssemblyName System.Windows.Forms

# Define the RECT structure and import user32.dll functions
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class Win32 {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

        [StructLayout(LayoutKind.Sequential)]
        public struct RECT {
            public int Left;
            public int Top;
            public int Right;
            public int Bottom;
        }
    }
"@

# Get the handle of the currently active window
$foregroundWindow = [Win32]::GetForegroundWindow()

# Get the screen that the window is currently displayed on
$currentScreen = [System.Windows.Forms.Screen]::FromHandle($foregroundWindow)

# Use the bounds of the current screen to consider the full screen size including its absolute position
$screenWidth = $currentScreen.Bounds.Width
$screenHeight = $currentScreen.Bounds.Height
$screenLeft = $currentScreen.Bounds.Left
$screenTop = $currentScreen.Bounds.Top

# Set desired window size as a percentage of screen size (e.g., 80% of screen width and 70% of screen height)
$percentageWidth = 0.65
$percentageHeight = 0.75
$desiredWidth = [Math]::Round($screenWidth * $percentageWidth)
$desiredHeight = [Math]::Round($screenHeight * $percentageHeight)

# Calculate new position to center the window on the current screen, considering the screen's absolute position
$newX = $screenLeft + ($screenWidth - $desiredWidth) / 2
$newY = $screenTop + ($screenHeight - $desiredHeight) / 2

# Move and resize the window to the new position and size
[Win32]::MoveWindow($foregroundWindow, $newX, $newY, $desiredWidth, $desiredHeight, $true)


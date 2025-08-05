using Windows.Win32;

namespace Interop;
public static class CloseWindowHelper
{
    /// <summary>Posts an SC_CLOSE message to the specified window.</summary>
    /// <param name="hWnd">The window handle specifying the window to close.</param>
    /// <returns>A boolean indicating if the operation was successful.</returns>
    public static bool CloseWindow(IntPtr hWnd)
    {
        return PInvoke.PostMessage(
            new Windows.Win32.Foundation.HWND(hWnd),
            PInvoke.WM_SYSCOMMAND,
            PInvoke.SC_CLOSE,
            IntPtr.Zero
        );
    }
}

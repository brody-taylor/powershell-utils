#pragma warning disable CA1416

using Windows.Win32;
using Windows.Win32.Devices.Display;
using System.Runtime.InteropServices;

namespace Interop;
public static class WindowsHDRHelper
{
    /// <summary>Retrieves display configurations for all active displays.</summary>
    /// <returns>An array containing all active display configurations.</returns>
    private static DISPLAYCONFIG_MODE_INFO[] GetDisplayConfigs()
    {
        PInvoke.GetDisplayConfigBufferSizes(
            QUERY_DISPLAY_CONFIG_FLAGS.QDC_ONLY_ACTIVE_PATHS,
            out uint numPaths,
            out uint numModes
        );
        var paths = new DISPLAYCONFIG_PATH_INFO[numPaths];
        var modes = new DISPLAYCONFIG_MODE_INFO[numModes];

        unsafe
        {
            fixed (DISPLAYCONFIG_PATH_INFO* pPaths = paths)
            fixed (DISPLAYCONFIG_MODE_INFO* pModes = modes)
            {
                PInvoke.QueryDisplayConfig(
                    QUERY_DISPLAY_CONFIG_FLAGS.QDC_ONLY_ACTIVE_PATHS,
                    ref numPaths,
                    pPaths,
                    ref numModes,
                    pModes,
                    null
                );
            }
        }

        return modes;
    }

    /// <summary>Enables or disables HDR for all active displays.</summary>
    /// <param name="enable">Flag indicating if HDR should be enabled or disabled.</param>
    /// <returns>A boolean indicating if the operation was successful.</returns>
    public static bool SetHDR(bool enable)
    {
        try
        {
            // Retrieve configs for all active displays
            DISPLAYCONFIG_MODE_INFO[] displayConfigs = GetDisplayConfigs();

            // Set HDR for each active display
            foreach (DISPLAYCONFIG_MODE_INFO displayConfig in displayConfigs)
            {
                DISPLAYCONFIG_SET_ADVANCED_COLOR_STATE setPacket = new()
                {
                    header = new DISPLAYCONFIG_DEVICE_INFO_HEADER
                    {
                        type = DISPLAYCONFIG_DEVICE_INFO_TYPE.DISPLAYCONFIG_DEVICE_INFO_SET_ADVANCED_COLOR_STATE,
                        size = (uint)Marshal.SizeOf<DISPLAYCONFIG_SET_ADVANCED_COLOR_STATE>(),
                        adapterId = displayConfig.adapterId,
                        id = displayConfig.id,
                    },
                };
                setPacket.Anonymous.Anonymous.enableAdvancedColor = enable;

                PInvoke.DisplayConfigSetDeviceInfo(setPacket.header);
            }
        }
        catch
        {
            return false;
        }

        return true;
    }
}

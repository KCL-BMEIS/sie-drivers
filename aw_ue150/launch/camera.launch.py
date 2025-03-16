from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.actions import ExecuteProcess
from launch.substitutions import LaunchConfiguration


def generate_launch_description() -> LaunchDescription:
    ld = LaunchDescription()

    ld.add_action(
        DeclareLaunchArgument(
            name="ip",
        )
    )
    ld.add_action(
        DeclareLaunchArgument(
            name="port",
            default_value="7002",
        )
    )

    # launch GStreamer bridge (doesn't use composition)
    ld.add_action(ExecuteProcess(cmd=["gst-launch-1.0", "-v", "srtsrc"]))
    #  \
    #     -v srtsrc uri="srt://172.22.86.98:7002?mode=listener" \
    #     ! tsdemux \
    #     ! h264parse \
    #     ! avdec_h264 \
    #     ! videoconvert \
    #     ! video/x-raw,format=RGB \
    #     ! rosimagesink

    return ld

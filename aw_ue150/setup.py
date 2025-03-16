from setuptools import find_packages, setup

package_name = "aw_ue150"

setup(
    name=package_name,
    version="0.0.1",
    packages=find_packages(exclude=["test"]),
    data_files=[
        ("share/ament_index/resource_index/packages", ["resource/" + package_name]),
        ("share/" + package_name, ["package.xml"]),
    ],
    install_requires=["setuptools"],
    zip_safe=True,
    maintainer="Yang-Li86, mhubii",
    maintainer_email="yang.7.li@kcl.ac.uk, martin.huber@kcl.ac.uk",
    description="ROS 2 driver for the AW-UE150 cameras",
    license="Apache-2.0",
    tests_require=["pytest"],
    entry_points={
        "console_scripts": [],
    },
)

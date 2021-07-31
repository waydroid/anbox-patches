#
# Copyright (C) 2021 The BlissLabs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

rompath="$PWD"
vendor_path="anbox"
temp_path="$rompath/vendor/$vendor_path/tmp/"
config_type="$1"

#setup colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
purple=`tput setaf 5`
teal=`tput setaf 6`
light=`tput setaf 7`
dark=`tput setaf 8`
ltred=`tput setaf 9`
ltgreen=`tput setaf 10`
ltyellow=`tput setaf 11`
ltblue=`tput setaf 12`
ltpurple=`tput setaf 13`
CL_CYN=`tput setaf 12`
CL_RST=`tput sgr0`
reset=`tput sgr0`

addRemove() {
	#~ echo "Adding		$1"
	echo -e "\t$1" >> "$temp_path/01-remove.xml"
}

readFile() {
	echo -e ${reset}""${reset}
	echo -e ${green}"00-remove.xml generation starting..."${reset}
	echo -e ${reset}""${reset}
	
	while IFS= read -r rpitem; do
		if grep -RlZ "$rpitem" $rompath/.repo/manifests/; then
			echo -e ${yellow}"	ROM already includes:	$rpitem"${reset}
		else
			prefix="<remove-project name="
			suffix=" />"
			item=${rpitem#"$prefix"}
			item=${item%"$suffix"}
			if grep -RlZ "$item" $rompath/.repo/manifests/; then
				addRemove "$rpitem"
			fi
		fi
	done < $rompath/vendor/$vendor_path/manifest_scripts/remove.lst
}


if [ -d $temp_path ]; then
	echo -e ${reset}""${reset}
	echo -e ${teal}"Temp Path Already Created, cleaning up"${reset}
	echo -e ${reset}""${reset}
	rm -rf "$temp_path/01-remove.xml"
else
	mkdir -p "$temp_path"
fi

if [ -d $rompath/.repo/local_manifests/ ]; then
	echo -e ${reset}""${reset}
	echo -e ${teal}"local_manifests Path Already Created"${reset}
else
	mkdir -p "$rompath/.repo/local_manifests/"
fi

echo -e '<?xml version="1.0" encoding="UTF-8"?>' > "$temp_path/01-remove.xml"
echo -e '<manifest>' >> "$temp_path/01-remove.xml"

readFile

echo -e '</manifest>' >> "$temp_path/01-remove.xml"

cp -r "$temp_path/01-remove.xml" $rompath/.repo/local_manifests/

cp -r $rompath/vendor/$vendor_path/manifest_scripts/manifests/*.xml $rompath/.repo/local_manifests

echo -e ${reset}""${reset}
echo -e ${green}"manifest generation complete. Files have been copied to $rompath/.repo/local_manifests"${reset}
echo -e ${reset}""${reset}

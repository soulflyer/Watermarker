script IWApertureAccess
	property parent : class "NSObject"
	
	on getLibrary()
		tell application "System Events" to set p_libPath to value of property list item "LibraryPath" of property list file ((path to preferences as Unicode text) & "com.apple.Aperture.plist")
		if ((offset of "~" in p_libPath) is not 0) then
			set p_script to "/bin/echo $HOME"
			set p_homePath to (do shell script p_script)
			set p_offset to offset of "~" in p_libPath
			set p_path to text (p_offset + 1) thru -1 of p_libPath
			return p_homePath & p_path
		else
			return p_libPath
		end if
	end getLibrary
	
	on getDatabase()
		set theLibrary to my getLibrary()
		return theLibrary & "/Database/Library.apdb"
	end getDatabase
	
	on getSelectedPhotos()
		-- returns an NSArray of NSDictionary
		-- IWApertureAccess *Aperture = [[NSClassFromString(@"IWApertureAccess") alloc] init];
		-- NSArray *photos=[Aperture getSelectedPhotos];
		-- NSString *firstPhotoMasterName=[photos[0] objectForKey:@"master"];
		tell application "Aperture"
			set cursel to the selection
			set theList to {}
			repeat with sel in cursel
				tell sel
					set theProject to value of other tag "MasterProject"
					set theProjectName to name of theProject
					set theMonth to (value of EXIF tag "CaptureMonthOfYear") as integer as string
					if length of theMonth is 1 then
						set theMonth to "0" & theMonth
					end if
					set theYear to value of EXIF tag "CaptureYear"
					set masterName to value of other tag "FileName"
					set theWaterMark to ""
					try
						set theWaterMark to value of IPTC tag "SpecialInstructions"
					end try
					--set thePicDetails to theYear & theMonth & theProjectName & name & masterName
					set thePicDetails to {|year|:theYear, |month|:theMonth, |project|:theProjectName, |name|:name, master:masterName, watermark:theWaterMark}
				end tell
				set end of theList to thePicDetails
			end repeat
		end tell
		return theList
	end getSelectedPhotos
	
	on writeIPTC:iptcData toField:iptcField ofPic:thePic ofProject:theProject ofMonth:theMonth ofYear:theYear
		set iptcData to iptcData as text
		set iptcField to iptcField as text
		set thePic to thePic as text
		set theProject to theProject as text
		set theMonth to theMonth as text
		set theMonth to my monthToString(theMonth)
		set theYear to theYear as text
		tell application "Aperture"
			tell folder theYear
				tell folder theMonth
					tell project theProject
						set sels to every image version where name is thePic
						set sel to first item of sels
						tell sel
							make new IPTC tag with properties {name:iptcField, value:iptcData}
						end tell
					end tell
				end tell
			end tell
		end tell
		return "Wrote " & iptcData & " to " & iptcField & " of " & theYear & "/" & theMonth & "/" & theProject & "/" & thePic
	end writeIPTC:toField:ofPic:ofProject:ofMonth:ofYear:
	
	on getPreviewOf:thePic ofProject:theProject ofMonth:theMonth ofYear:theYear
		-- This could just as easily be done in objc, but logically it fits here with the other aperture access methods
		set thePath to my getLibrary()
		set thePath to thePath & "/Previews/" & theYear & "/" & theMonth
		set theScript to "find " & quoted form of thePath & " -name " & thePic & ".*"
		try
			set result to do shell script theScript
			--log thePath
			return result as text
		on error
			return "Can't_find_" & thePic
		end try
	end getPreviewOf:ofProject:ofMonth:ofYear:
	
	on monthToString(monthint)
		set theDate to current date
		set month of theDate to monthint
		return month of theDate as text
	end monthToString
	
end script
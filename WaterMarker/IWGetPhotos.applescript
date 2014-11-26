script IWGetPhotos
	property parent : class "NSObject"	
	on getPhotos()
		--log "hi"
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
					set thePicDetails to theYear & theMonth & theProjectName & name & masterName
				end tell
				set end of theList to thePicDetails
			end repeat
		end tell
		return theList
	end getPhotos	
end script
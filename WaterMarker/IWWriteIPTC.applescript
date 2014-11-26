script IWWriteIPTC
	property parent : class "NSObject"	
	on writeIPTC:iptcData toField:iptcField ofPic:thePic ofProject:theProject ofMonth:theMonth ofYear:theYear
		set iptcData to iptcData as text
		set iptcField to iptcField as text
		set thePic to thePic as text
		set theProject to theProject as text
		set theMonth to theMonth as text
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
end script
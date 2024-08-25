;----------------------------------------------------------------------------------------------------------------------
; This code is free software: you can redistribute it and/or modify  it under the terms of the 
; version 3 GNU General Public License as published by the Free Software Foundation.
; 
; This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without even 
; the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
; See the GNU General Public License for more details (https://www.gnu.org/licenses/gpl-3.0.html)
;
; WARNING TO USERS AND MODIFIERS
;
; This script contains "Buy me a coffee" links to honor the author's hard work and dedication in creating
; all the features present in this code. Removing or altering these links not only violates the GPL license
; but also disregards the significant effort put into making this script valuable for the community.
;
; If you find value in this script and would like to show appreciation to the author,
; kindly consider visiting the site below and treating the author to a few cups of coffee:
;
; https://www.buymeacoffee.com/screeneroner
;
; Your honor and gratitude is greatly appreciated.
;----------------------------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------------------
/*
User Guide:

This script automatically changes your desktop wallpaper 
at a specified interval using free random images 
from an online source (https://picsum.photos/). 
The script uses the primary monitor's resolution 
as the default wallpaper size that may be changed later.

Features implemented in right click tray menu items:
1. Force Reload: Immediately change the wallpaper to a new random image.
2. Save Current Image: Save the current wallpaper to a file with a timestamp.
3. Set Image Size: Customize the wallpaper size by entering desired dimensions as WIDTHxHEIGHT.
4. Set Interval: Set the time interval (in minutes, can be fractional like 0.5) for changing wallpapers.
5. Buy Me a Coffee: Opens a link where you can support the developer.

Usage:
- Right-click the tray icon to access the menu options.
- Double-click the tray icon to force a wallpaper change immediately.
- Saved images are stored in the script directory with the current date and time as the filename.
*/
;----------------------------------------------------------------------------------------------------------------------

#Persistent
#SingleInstance Force
Menu, Tray, NoStandard
Menu, Tray, Add, Force Reload, ChangeWallpaper
Menu, Tray, Add, Save current image, SaveCurrentImage
Menu, Tray, Add
Menu, Tray, Add, Set Image Size, SetImageSize
Menu, Tray, Add, Set Interval (m), SetInterval
Menu, Tray, Add
Menu, Tray, Add, Buy me a coffee, BuyCoffee 
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Default, Force Reload
Menu, Tray, Click, 1

Menu, Tray, Icon, Shell32.dll, 162
Menu, Tray, Icon, Force Reload, %SystemRoot%\System32\shell32.dll,239
Menu, Tray, Icon, Save current image, %SystemRoot%\System32\shell32.dll,259
Menu, Tray, Icon, Set Image Size, %SystemRoot%\System32\shell32.dll,241
Menu, Tray, Icon, Set Interval (m), %SystemRoot%\System32\shell32.dll,240
Menu, Tray, Icon, Buy me a coffee, Coffee.ico
Menu, Tray, Icon, Exit, %SystemRoot%\System32\shell32.dll,28

global interval, width, height

; Get the primary monitor's screen size
SysGet, MonitorPrimary, Monitor
width := MonitorPrimaryRight - MonitorPrimaryLeft
height := MonitorPrimaryBottom - MonitorPrimaryTop
interval := 60000
SetTimer, ChangeWallpaper, %interval%
formattedInterval := Format("{:.1f}", interval / 60000.0) ; Convert interval to minutes
Menu, Tray, Tip, Wallpaper changing every %formattedInterval% min


return

ChangeWallpaper() {
	global width, height
	UrlDownloadToFile, https://picsum.photos/%width%/%height%, %A_ScriptDir%\wallpaper.jpg
	DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", A_ScriptDir "\wallpaper.jpg", "UInt", 1)
}

SaveCurrentImage() {
	global interval
	FormatTime, timestamp,, yyyy-MM-dd HH-mm-ss
	FileCopy, %A_ScriptDir%\wallpaper.jpg, %A_ScriptDir%\%timestamp%.jpg
	TrayTip, Current wallpaper saved, %timestamp%.jpg ,1, 17
}


SetImageSize() {
	global width, height
	InputBox, size, Set new picture size, Current Image Size %width%x%height%`nEnter the new picture size
	if !ErrorLevel
	{
		; Correctly match width and height from input
		if RegExMatch(size, "(\d+)\D+(\d+)", m)
		{
			width := m1
			height := m2
		}
		ChangeWallpaper()
	}
}

SetInterval() {
	global interval
	formattedInterval := Format("{:.1f}", interval / 60000.0) ; Format interval to 0.0
	InputBox, t, Set new refresh interval (in minutes), Current Interval %formattedInterval%`nEnter new refresh interval
	if !ErrorLevel {
		SetTimer, ChangeWallpaper, % interval := t * 60000
		formattedInterval := Format("{:.1f}", interval / 60000.0) ; Convert interval to minutes
		Menu, Tray, Tip, Wallpaper changing every %formattedInterval% min
	}
}

BuyCoffee() {
    Run, https://www.buymeacoffee.com/screeneroner
}

ExitApp() {
	ExitApp
}
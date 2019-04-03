
C4:UpdateProperty( "State", "Unconnected" );

connected = false;

function Connect()

	if ( socket ~= nil ) then return end

	print( "Connecting to " .. Properties[ "Server Address" ] .. ":" .. Properties[ "Server Port" ] );
	
    socket = C4:CreateTCPClient()
    socket:Option( "keepalive", true )
	socket:Option( "nodelay", true )

	socket:OnConnect(function(client)
		print("OnConnect")
	end)

	socket:OnDisconnect(function(client, errCode, errMsg)

		if (errCode ~= 0) then
			print( "Disconnected with error " .. errCode .. ": " .. errMsg)
		else
			print( "Disconnected and no response received")
		end

		socket = nil

	end)

	socket:OnError(function(client, errCode, errMsg)

		print( "Error " .. errCode .. ": " .. errMsg)
		socket = nil

	end)

    
	socket:Connect( Properties[ "Server Address" ], Properties[ "Server Port" ] )
	
end

function OnDriverLateInit()

	Connect();

end


function ReceivedFromProxy(idBinding, strCommand, tParams)

    if ( idBinding == 5000 ) then 
    
	   Connect();
	   
	   if ( strCommand == "ENTER" ) then strCommand = "RETURN" end
	   if ( strCommand == "PVR" ) then strCommand = "F11" end
	   if ( strCommand == "CANCEL" ) then strCommand = "ESCAPE" end
	   if ( strCommand == "SCAN_REV" ) then strCommand = "Z" end
	   if ( strCommand == "SCAN_FWD" ) then strCommand = "X" end
    
	   socket:Write( "VK_" .. strCommand .. "\r" );
    end

end


function OnPropertyChanged(strProperty)

    if ( strProperty == "Server Address" ) then Connect() end
    if ( strProperty == "Server Port" ) then Connect() end

end

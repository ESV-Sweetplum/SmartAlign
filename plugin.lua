-- Original code by Kusa

function draw()
    imgui.Begin("Align")

    state.IsWindowHovered = imgui.IsWindowHovered()

    local timingpoint = state.CurrentTimingPoint
    local starttime = timingpoint.StartTime
    local length = map.GetTimingPointLength(timingpoint)
    local endtime = starttime + length
    local signature = timingpoint.Signature
    local bpm = timingpoint.Bpm
    local mspb = 60000 / bpm
    local msptl = mspb * signature

    if imgui.Button("Align Timing Points with Notes") then
        local times = {}
        local timingpoints = {}
        for time=starttime,endtime,msptl do
            local tempTime = math.floor(time) + 2
            table.insert(times, map.GetNearestSnapTimeFromTime(false, 1, tempTime))
        end
        for _,time in pairs(times) do
            table.insert(timingpoints, utils.CreateTimingPoint(time,bpm,signature))
        end
        actions.RemoveTimingPoint(timingpoint)
        actions.PlaceTimingPointBatch(timingpoints)
    end
    
    imgui.Text("StartTime: " .. starttime)
    imgui.Text("EndTime: " .. endtime)
    imgui.Text("BPM: " .. bpm)
    imgui.Text("Length: " .. length)
    imgui.Text("MsPB: " .. mspb)
    imgui.Text("MsPTL: " .. msptl)

    imgui.End()
end

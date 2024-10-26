-- Original code by Kusa

function draw()
    imgui.Begin("SmartAlign")

    local timingpoint = state.CurrentTimingPoint
    local starttime = timingpoint.StartTime
    local length = map.GetTimingPointLength(timingpoint)
    local endtime = starttime + length
    local signature = state.GetValue("signature") or 4
    if (timingpoint.Signature == time_signature.Quadruple) then
        signature = 4
    elseif (timingpoint.Signature == time_signature.Triple) then
        signature = 3
    end
    local bpm = timingpoint.Bpm
    local mspb = 60000 / bpm
    local msptl = mspb * signature

    local noteTimes = {}

    for _, n in pairs(map.HitObjects) do
        table.insert(noteTimes, n.StartTime)        
    end

    if imgui.Button("Align Timing Points with Notes") then
        local times = {}
        local timingpoints = {}
        for time=starttime,endtime,msptl do
            local originalTime = math.floor(time)
            while (noteTimes[1] < originalTime - 5) do
                table.remove(noteTimes, 1)
            end
            if (math.abs(noteTimes[1] - originalTime) <= 5) then
                table.insert(times, noteTimes[1])
            else
                table.insert(times, originalTime)
            end
        end
        for _,time in pairs(times) do
            table.insert(timingpoints, utils.CreateTimingPoint(time,bpm,signature))
        end
        actions.PerformBatch({
            utils.CreateEditorAction(action_type.AddTimingPointBatch, timingpoints),
            utils.CreateEditorAction(action_type.RemoveTimingPoint, timingpoint)
        })
    end
    
    imgui.Text("Will Align From: " .. starttime)
    imgui.Text("Will Align To: " .. endtime)
    imgui.Text("Current BPM: " .. bpm)
    imgui.InputInt("Current Signature: ", signature)

    state.SetValue("signature", signature)

    imgui.End()
end

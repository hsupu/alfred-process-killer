#query_str = "-USR1 php"
query_str = "{query}"

# 假定请求是以空格分割，并有 名称 和 参数 两部分
query_info = query_str.split(" ")

query_name = Array.new
query_opts = Array.new

# sudo kill 模式下改值默认为 true
is_sudo = false
sudo_pwd = ""

query_info.each do | arg |
    if arg == "sudo" then
        is_sudo = true
    elsif arg[0, 2] == "-p" then
        if arg.length > 2 then sudo_pwd = arg[2..-1] end
    elsif arg[0] == "-" then
        if arg.length > 1 then query_opts.push(arg) end
    else
        query_name.push(arg)
    end
end
# 未输入匹配串则不查询
if query_name.length == 0 then exit end

def exit_no_matched()
    xml =  "<?xml version=\"1.0\"?>\n<items>
            <item uid=\"\" arg=\"\">
                <title>No process matched</title>
                <subtitle>Maybe you should try another name</subtitle>
                <icon type=\"\"></icon>
            </item>\n</items>"
    puts xml
    exit
end

# 合并参数串
query_opts = query_opts.join(" ")
# 合并匹配串（不区分大小写）
grep_str = "grep -i \"" + query_name.join("\" | grep -i \"") + "\""

if is_sudo == true then
    if sudo_pwd != "" then
        kill_script = "echo #{sudo_pwd} | sudo -S kill #{query_opts}"
    else
        kill_script = "kill #{query_opts}"
    end
    processes = `ps -A -o pid -o comm | #{grep_str}`.split("\n")
else
    kill_script = "kill #{query_opts}"
    processes = `ps -x -o pid -o comm | #{grep_str}`.split("\n")
end

# 获取 PIDs
pids = Array.new
processes.each do | process |
    pids.push(process.match(/\s*(\d+)\s+/).captures)
end
if pids.length == 0 then exit_no_matched() end
pids = pids.join(",")

# 获取详细信息
processes = `ps -p #{pids} -o pid -o %cpu -o %mem -o uid -o user -o comm`.split("\n")
# 删除标题栏
processes.shift()
if processes.length == 0 then exit_no_matched() end

# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
xml = "<?xml version=\"1.0\"?>\n<items>\n"

processes.each do | process |

    pid, cpu_used, mem_used, uid, user, cmd = process.match(/(\d+)\s+(\d+[\.|\,]\d+)\s+(\d+[\.|\,]\d+)\s+(\d+)\s+(\w+)\s+(.*)/).captures

    # Use the same expression as before to isolate the name of the process.
    name = cmd.match(/[^\/]*$/i)
    # Search for an application bundle in the path to the process.
    iconValue = cmd.match(/.*?\.app\//)
    # The icon type sent to Alfred is 'fileicon' (taken from a file). This assumes that a .app was found.
    iconType = "fileicon"
    # If no .app was found, use OS X's generic 'executable binary' icon.
    # An empty icon type tells Alfred to load the icon from the file itself, rather than loading the file type's icon.
    if !iconValue then
        iconValue = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ExecutableBinaryIcon.icns"
        iconType = ""
    end
    # Assemble this item's XML string for Alfred. See http://www.alfredforum.com/topic/5-generating-feedback-in-workflows/
    # Append this process's XML string to the global XML string.
    xml += "\t<item uid=\"#{cmd}\" arg=\"#{kill_script},#{pid},#{name}\">
        <title>[#{pid}] #{name}</title>
        <subtitle>[#{uid}] #{user} #{cpu_used}% CPU #{mem_used}% CPU @ #{cmd}</subtitle>
        <icon type=\"#{iconType}\">#{iconValue}</icon>
    </item>\n"

end

# Finish off and echo the XML string to Alfred.
xml += "</items>"
puts xml

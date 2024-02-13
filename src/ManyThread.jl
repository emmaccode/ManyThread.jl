module ManyThread
using Toolips
using Toolips.Components
# extensions
logger = Toolips.Logger()

# routes
clients = 0

function otherpage(client::Int64)
    greeter = h2("maingreeting", text = "hello!")
    curr_client = h3("clientn", text = "you are client number ...")
    num = a("num", text = string(client))
    maindiv = div("maindiv")
    sleep(3)
    push!(maindiv, greeter, curr_client, num)
    maindiv::Component{:div}
end

main = route("/") do c::Connection
    c[:clients] += 1
    job = new_job(otherpage, c[:clients])
    as_thread = assign_open!(c, job)
    page = waitfor(c, as_thread ...)[1]
    @info "a client was served by thread $(as_thread[1])"
    push!(page, h4("thread", text = "served from thread $(as_thread[1])"))
    write!(c, page)
end

mobile = route("/") do c::Toolips.MobileConnection

end


# multiroute
home = route(main, mobile)

# docs & api manager (/doc && /toolips)
api_man = toolips_app
docs = toolips_doc

module SingleThread
using Toolips
using Toolips.Components

clients = 0
function otherpage(client::Int64)
  greeter = h2("maingreeting", text = "hello!")
  curr_client = h3("clientn", text = "you are client number ...")
  num = a("num", text = string(client))
  maindiv = div("maindiv")
  sleep(3)
  push!(maindiv, greeter, curr_client, num)
  maindiv::Component{:div}
end

main = route("/") do c::Connection
  c[:clients] += 1
  page = otherpage(c[:clients])
  @info "a client was served by the regular process"
  push!(page, h4("thread", text = "served from a single thread"))
  write!(c, page)
end

mobile = route("/") do c::Toolips.MobileConnection

end

home = route(main, mobile)

export home, otherpage, default_404, clients
end # module SingleThread

export home, otherpage, default_404, clients
export api_man, docs
export logger
end # - module


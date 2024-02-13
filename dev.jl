using Pkg; Pkg.activate(".")
using Revise
using Toolips
using ManyThread
toolips_process = start!(ManyThread, threads = 4)
@everywhere using ManyThread
@everywhere using Toolips
toolips_process
start!(ManyThread.SingleThread, ip = "127.0.0.1":8001)
class ProcessTestController < ApplicationController
  class NoConnectionError < StandardError
  end
  rescue_from NoConnectionError, with: :restart_puma_worker

  def raise_error
    puts "噴噴噴大爆射Error"
    raise NoConnectionError
    return render json:{message:"應該要噴一個error才對"}
  end

  def restart_puma_worker
    puts "Send USR1 to #{Process.ppid}"
    Process.kill("USR1", Process.ppid)
    Process.wait(-1, Process::WNOHANG)
  end
end

defmodule Mspoller do
  @moduledoc """
  Generated by erl2ex (http://github.com/dazuma/erl2ex)
  From Erlang source: (Unknown source file)
  At: 2019-12-20 13:57:27

  """

  def main() do
    {:ok, context} = :erlzmq.context()
    {:ok, receiver} = :erlzmq.socket(context, [:pull, {:active, true}])
    :ok = :erlzmq.connect(receiver, 'tcp://localhost:5557')
    {:ok, subscriber} = :erlzmq.socket(context, [:sub, {:active, true}])
    :ok = :erlzmq.connect(subscriber, 'tcp://localhost:5556')
    :ok = :erlzmq.setsockopt(subscriber, :subscribe, "10001")
    loop(receiver, subscriber)
    :ok = :erlzmq.close(receiver)
    :ok = :erlzmq.close(subscriber)
    :ok = :erlzmq.term(context)
  end


  def loop(tasks, weather) do
    receive do
      {:zmq, ^tasks, msg, _flags} ->
        :io.format('Processing task: ~s~n', [msg])
        loop(tasks, weather)
      {:zmq, ^weather, msg, _flags} ->
        :io.format('Processing weather update: ~s~n', [msg])
        loop(tasks, weather)
    end
  end

end

Mspoller.main

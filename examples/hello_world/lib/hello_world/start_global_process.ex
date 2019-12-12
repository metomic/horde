defmodule Horde.StartGlobalProcess do
  use GenServer

  def child_spec(_) do
    %{start: {__MODULE__, :start_link, []}, id: __MODULE__, restart: :transient}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    {:ok, _pid} =
      Horde.DynamicSupervisor.start_child(
        HelloWorld.HelloSupervisor,
        HelloWorld.SayHello
      )

    :ignore
  end
end

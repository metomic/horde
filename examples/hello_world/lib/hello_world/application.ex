defmodule HelloWorld.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Horde.Registry,
       [name: HelloWorld.HelloRegistry, keys: :unique, members: registry_members()]},
      {Horde.DynamicSupervisor,
       [
         name: HelloWorld.HelloSupervisor,
         strategy: :one_for_one,
         distribution_strategy: Horde.UniformDistribution,
         members: supervisor_members()
       ]},
      Horde.StartGlobalProcess,
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies)]}
    ]

    opts = [strategy: :one_for_one, name: HelloWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def how_many?() do
    Horde.Registry.meta(HelloWorld.HelloRegistry, "count")
  end

  defp registry_members do
    [
      {HelloWorld.HelloRegistry, :"count1@127.0.0.1"},
      {HelloWorld.HelloRegistry, :"count2@127.0.0.1"},
      {HelloWorld.HelloRegistry, :"count3@127.0.0.1"}
    ]
  end

  defp supervisor_members do
    [
      {HelloWorld.HelloSupervisor, :"count1@127.0.0.1"},
      {HelloWorld.HelloSupervisor, :"count2@127.0.0.1"},
      {HelloWorld.HelloSupervisor, :"count3@127.0.0.1"}
    ]
  end
end

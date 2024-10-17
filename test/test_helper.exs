ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Sonet.Repo, :manual)

# added
SonetLib.TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(SonetLib.TestRepo, :manual)

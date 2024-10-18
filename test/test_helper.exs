use Sonet.Prelude

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)

# added
use SonetLib.TestPrelude

TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)

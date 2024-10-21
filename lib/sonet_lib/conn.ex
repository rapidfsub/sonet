defmodule SonetLib.Conn do
  use SonetLib.Prelude

  use Delegate, [
    {Phoenix.ConnTest,
     [
       build_test_conn: [arity: 0, as: :build_conn]
     ]},
    {Plug.Conn,
     [
       put_req_header: 3
     ]}
  ]
end

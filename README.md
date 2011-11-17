# FakeWeb.js


    FakeWeb.get "/foo/bar", success: ->
      {id: 1, name: "Mark"}
      
    FakeWeb.post "/users", success: ->
      {id: 1, name: "Mark"}

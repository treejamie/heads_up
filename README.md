# Heads Up


## 🗃️ Database

The local database is being ran with a pod using podman. Note, this one runs a port higher tp allow for both apps to be ran at the same time.

```bash
podman run --rm -p 5433:5432 -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=heads_up_dev -v $HOME/pods/heads_up:/var/lib/postgresql/data postgres -d postgres
```

## 🌐 Web Server

Start interactive server - note, just like the database, this app runs one port higher to allow for both apps to be ran at the same time.

```
iex -S mix phx.server
```

Now you can visit [`localhost:4001`](http://localhost:4001) from your browser.



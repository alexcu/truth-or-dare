# Truth or Dare

A classic Truth or Dare game for OS X running beautifully in the command line.

<div style="background-color: rgba(25,25,25,0.78); border-radius: 1em; padding: 1em; margin-bottom: 1em;">
  <img src="http://puu.sh/mAcgR/8966193fe3.png"><br>
  <img src="http://puu.sh/mAc6a/5b1ee6920c.png">
</div>

Provides 3 levels of fun:

1. Clean
2. Naughty *(NSFW-ish)*
3. Dare Devil *(NSFW)*

## How to build

Open the directory and run `make`:

```bash
$ /path/to/TruthOrDare
$ make
```

This will compile everything into `/Build/Debug`. The executable for you to run
is `/Build/Debug/TruthOrDare`

## How to play

To play, you'll need to grab a copy of the [database file](http://stuff.alexcu.me/protected/questions.db).
People who know me can ask for the password for this file 😏

Place this database file either in the `/Build/Debug` directory sitting aside
the `TruthOrDare` executable or else execute `TruthOrDare` providing the **absolute**
path to your database file:

```bash
$ ./Build/Debug/TruthOrDare /path/to/questions.db
```

## License

&copy; Alex Cummaudo 2014. All rights reserved.

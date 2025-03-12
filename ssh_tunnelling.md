# Connect to Cameras Remotely

On the bouncer or a machine within the BMEIS network:

```bash
ssh -L 5555:172.22.100.1:80 <USERNAME>@siedgx01.isd.kcl.ac.uk
```

If you are using bouncer, on your local machine:

```bash
ssh -L 5555:localhost:5555 <USERNAME>@bouncer.isd.kcl.ac.uk
```

Note that port 5555 is chosen randomly, you can use any other ports as you like, just keep them consistant.

Then, if you open the browser on your local machine, and enter the following URL:

```
localhost:5555
```

You should be able to see the web interface of the camera.
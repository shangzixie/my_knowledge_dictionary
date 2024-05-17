# redirection

The simplest form of redirection is < file and > file. These let you rewire the input and output streams of a program to a file respectively:

```shell
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```

## Difference between `>` and `>>` in Linux

the `>` will overwrite the content, but `>>` will append the content
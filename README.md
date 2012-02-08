This is a command-line interface tool to ProcessOne Push Platform.

Example usage:

First define you XMPP username and password in config file to avoid to have to pass it from command-line.
For example, put this in ~/.p1pp.conf

```
---
:jid: test@gmail.com
:password: test

commands:
  :create: {}
  :list: {}
  :listen: {}
  :subscribe: {}
  :publish: {}
```

You can then create a first pubsub node with the following command:

$ p1.rb create test1
User: test@gmail.com
Created node test1

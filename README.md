Editor simulator program, working with image (fake) <br />
to launch please write in console: ruby server.rb

Stack too deep if image pixels has more to colored then m*n*4 > 8000

# Overall comments:
- impressive number of tests
- test descriptions could be clearer, don't disregard this
- method names could be clearer.
  I see what you're trying to do but better method name would make my life much easier.
- Spelling. I know it may not sound like a big deal but it may cost you an inteview one day,
  some devs are fussy about it.
- Overall, you have a very tight coupling of errors handing and data checking,
  this is one of the biggest problems here
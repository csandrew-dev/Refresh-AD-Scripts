# Refresh-AD-Scripts
Scripts that Refresh can use for automation


Query AD or QAD
Script that takes in a machine name and returns the distingushed name and groups that object is in. This is useful for techs to be able quickly tell if the machine has been added to the refresh group (for TS availability) and AD location (if asset info needs updating or that is causing issues like certain applications aren't available in SC)
very handy because ADUC is clunky and slow sometimes.


ComputerNameGatherScript and AddADGroupScript
Proof of concept scripts of a tool that would allow refresh techs (no edit access in AD) to add computers to a group in an organized, secure, and traceable way. 
Unfortunately didn't get implemented.

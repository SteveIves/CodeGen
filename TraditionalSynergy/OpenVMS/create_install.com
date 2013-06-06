$ !
$ LOCATION = F$PARSE(F$ENVIRONMENT("PROCEDURE"),,,"DEVICE") + F$PARSE(F$ENVIRONMENT("PROCEDURE"),,,"DIRECTORY")
$ !
$ SET DEF 'LOCATION
$ CREATE/DIR [.KIT]
$ CREATE/DIR [.KIT.TEMPLATES]
$ !
$ ! Copy the main program files
$ !
$ COPY [.EXE]CODEGEN.EXE				[.KIT]
$ COPY [.EXE]CREATEFILE.EXE				[.KIT]
$ COPY [.EXE]DATAMAPPINGSEXAMPLE.XML	[.KIT]
$ COPY [.EXE]DEFAULTBUTTONS.XML			[.KIT]
$ COPY [.EXE]MAPPREP.EXE				[.KIT]
$ COPY [.EXE]RPSINFO.EXE				[.KIT]
$ COPY INSTALL_SETUP.COM				[.KIT]CODEGEN_SETUP.COM
$ !
$ ! Copy all the template files
$ !
$ COPY [-.-.TEMPLATES]*.*;				[.KIT.TEMPLATES]
$ !
$ ! Create the backup saveset and Zip it
$ !
$ SET DEF [.KIT]
$ BACKUP [...]*.*; [-]CODEGEN.BCK/SAVE
$ SET DEF [-]
$ !
$ !This ZIP command assumes Zip V2.3 from Info-Zip
$ ZIP "-V" "-D" -j -q  CODEGEN.ZIP CODEGEN.BCK INSTALL_README.TXT
$ !
$ ! Clean up
$ !
$ DELETE/NOCONFIRM/NOLOG CODEGEN.BCK;*
$ DELETE/NOCONFIRM/NOLOG [.KIT...]*.*;*
$ DELETE/NOCONFIRM/NOLOG [.KIT...]*.*;*
$ DELETE/NOCONFIRM/NOLOG KIT.DIR;*
$ !
$ EXIT
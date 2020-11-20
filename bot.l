#!/usr/bin/pil

(load "irc.l")

(de i_connect ( host port )
    (if2 host port
        (or
            (connect host port)
            (quit (prinl "ERROR: Failed to connect to host " host " on port " port ".")))
        (prinl "ERROR: Port can not be NIL!")
        (prinl "ERROR: Host can not be NIL!")
        (prinl "ERROR: Invalid arguments!")))

(de i_auth ( sock nick pass )
    (prinl ">> Authing: " nick " / " pass)
    (out sock
        (prin "USER " nick " 0 * : " nick "^M^J")
        (prin "NICK " nick "^M^J")))

(de i_privmsg ( sock dst msg )
        (out sock (prin "PRIVMSG " dst " : " msg "^M^J")))

(de i_join ( sock chan )
    (out sock (prin "JOIN " chan "^M^J")))

(de i_part ( sock chan msg )
    (out sock (prin "PART " chan " : " msg "^M^J")))

(de pingp ( S )
    (= (car S) "PING"))

(de reply ( sock S msg )
    (i_privmsg sock (car (nth S 3)) msg))

(de handle_privmsg ( sock S )
    (if (= (car (nth S 4)) (pack ":" *b_nick ":"))
        (case (car (nth S 5))
            # explicitly define which scripts
            # can be run. Add scripts as you go
            ("test1" (reply sock S (run-script "test1.sh")))
            ("test2" (reply sock S (run-script "test2.sh"))))))

(de run-script ( afile )
    (prinl "RECEIVED " afile)
    # Yes, yes this is stupid and
    # insecure as fuck. Go away.
    (in (list (pack "scripts/" afile)) (line T)))

(de handle-line ( sock L )
    (prinl L)
    (let S (splitstr L)
        (if (pingp S)
        (out sock
            (prinl "PONG " (car (nth S 2)))))
        (case (car (nth S 2))
            ("PRIVMSG" (handle_privmsg sock S))))
    # bad! fix me!
    (= 1 1))

(de splitstr ( str )
    (mapcar pack (split (chop str) " ")))

(let (sock (i_connect *i_server *i_port))
    (wait 1000)
    (i_auth sock *b_nick *b_realname)
    (wait 1000)
    (for channel *b_channels
        (i_join sock channel))
    (in sock (while (line)
        (handle-line sock @))))

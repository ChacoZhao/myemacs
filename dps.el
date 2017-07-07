;; switch window
(defun sw_window()
  (other-window 1))

(defun kvL(address)
  (insert "kvn L=" address "\n")
  )
(defun dpsall(ll)
  (mapcar 'kvL ll)
  )

(defun print-list(ll)
  (mapcar 'message ll)
  )

(defun runcdb(dumpfile pdbfolder)
  "runcdb and set pdbpath"
  (interactive "fImput dump file path:\nfImput pdb folder:")

  (let ((msfolder "F:\\myms\\ms")
	)
    (insert "F:\\02tools\\Debuggers\\x86\\cdb -z \"" dumpfile "\"\n")
    (insert (format ".sympath %s;SRV*%s*http://msdl.microsoft.com/download/symbols\n" pdbfolder msfolder))
    )
  )

;find "except" => up line => first => 0170ea70
;0170ea70  0170f470
;0170ea74  776ecb00 KERNELBASE!_except_handler4
(defun find_ebp()
  "dps esp l1000"
  (sw_window)
  (goto-char (point-min))
  
  (let ((match-count 0)
	(match-list '())
	(match-debug '())
	(t4)
	(t5)
	(t6)
	)
    
    (while (re-search-forward "\\w*except" nil t 1)
      (setq match-count (+ match-count 1))
      
      (setq t4 (match-end 0))
      
      (search-backward "\n" nil 1 2)
      (setq t5 (match-beginning 0))
      (search-forward " " nil 1 1)
      (setq t6 (match-beginning 0))
      (push (format "%d, %d,  %s" t5 t6 (buffer-substring (+ t5 1) t6)) match-debug)
      (push (buffer-substring (+ t5 1) t6) match-list)
      
      (goto-char t4)
       )
;  (message "find except wording  %d times"  match-count)
; (print-list match-debug)
    (goto-char (point-max))
    (dpsall match-list)
  )
)
(find_ebp)
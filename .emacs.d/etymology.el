;; Etymology n' stuff!
(defun de-latinize (str)
  (let ((mapping '((?ū . ?u)
                   (?ā . ?a)
                   (?ē . ?e)
                   (?ī . ?i)
                   (?ō . ?o))))
    (mapcar (function (lambda (x)
                        (alist-get x mapping x 0)))
            str)))

(defun eww-wiktionary (word)
  (eww (concat
        "https://en.wiktionary.org/wiki/"
        (de-latinize (replace-regexp-in-string " " "_" word)))))

(defun lookup-wiktionary ()
  (interactive)
  (let (word)
    (setq word
          (if (use-region-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (current-word)))
    (eww-wiktionary word)))
(global-set-key (kbd "C-c w") 'lookup-wiktionary)
(global-set-key (kbd "C-c C-w")
                (lambda ()
                  (interactive)
                  (eww-wiktionary (read-string "Lookup word: "))))

(defun eww-etymonline (word)
  (eww (concat
        "http://www.etymonline.com/index.php?allowed_in_frame=0&search="
        (de-latinize (replace-regexp-in-string " " "%20" word)))))

(defun lookup-etymonline ()
  (interactive)
  (let (word)
    (setq word
          (if (use-region-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (current-word)))
    (eww-etymonline word)))
(global-set-key (kbd "C-c e") 'lookup-etymonline)
(global-set-key (kbd "C-c C-e")
                (lambda ()
                  (interactive)
                  (eww-etymonline (read-string "Lookup word: "))))

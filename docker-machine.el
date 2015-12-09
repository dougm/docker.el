;;; docker-machine.el --- Emacs interface to docker-machine

;; Author: Philippe Vaucher <philippe.vaucher@gmail.com>
;; URL: https://github.com/Silex/docker
;; Keywords: filename, convenience

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 'dash)

(defun docker-machine-read-name ()
  "Completing read of docker-machine name."
  (let* ((lsout (shell-command-to-string "docker-machine ls"))
         (lines (cdr (split-string lsout "\n" t))))
    (completing-read "Machine: " (--map (car (split-string it)) lines))))

(defun docker-machine-setenv (name)
  "Set docker-machine environment variables for machine NAME."
  (interactive (list (docker-machine-read-name)))
  (with-temp-buffer
    (let ((cmd (concat "docker-machine env --shell emacs"
                       (if current-prefix-arg " --swarm"))))
      (shell-command (concat cmd " " name) (current-buffer)))
    (eval-buffer)))

(defun docker-machine-unsetenv ()
  "Unset docker-machine environment variables."
  (interactive)
  (with-temp-buffer
    (shell-command "docker-machine env --shell emacs --unset" (current-buffer))
    (eval-buffer)))

(provide 'docker-machine)

;;; docker-machine.el ends here

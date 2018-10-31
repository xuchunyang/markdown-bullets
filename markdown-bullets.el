;;; markdown-bullets.el --- Prettify Markdown Headings -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Xu Chunyang

;; Author: Xu Chunyang <mail@xuchunyang.me>
;; Created: 2018-10-31
;; Homepage: https://github.com/xuchunyang/markdown-bullets
;; Requires-Packages: ((emacs "25"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Markdown port of https://github.com/emacsorphanage/org-bullets

;;; Code:

(defvar markdown-bullets-bullet-list
  '("◉"
    "○"
    "✸"
    "✿"))

(defun markdown-bullets--level-char (level)
  (string-to-char
   (nth (mod (1- level)
             (length markdown-bullets-bullet-list))
        markdown-bullets-bullet-list)))

(defvar markdown-bullets--keywords
  '(("^\\(#+\\) "
     (1 (prog1 nil
          (let* ((beg (match-beginning 1))
                 (end (match-end 1))
                 (end-1 (1- end)))
            ;; ### Heading 3
            ;;   ✸
            (compose-region end-1 end (markdown-bullets--level-char (- end beg)))
            (put-text-property beg end-1
                               'face (list :foreground
                                           (face-attribute
                                            'default :background)))))))))

(defun markdown-bullets--fontify-buffer ()
  (when font-lock-mode
    (save-restriction
      (widen)
      (font-lock-flush)
      (font-lock-ensure))))

;;;###autoload
(define-minor-mode markdown-bullets-mode
  "Prettify Markdown Headings."
  nil nil nil
  (if markdown-bullets-mode
      (progn
        ;; 'end is important
        (font-lock-add-keywords nil markdown-bullets--keywords 'end)
        (markdown-bullets--fontify-buffer))
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (while (re-search-forward "^#+ " nil t)
          (decompose-region (match-beginning 0) (match-end 0)))
        (font-lock-remove-keywords nil markdown-bullets--keywords)
        (markdown-bullets--fontify-buffer)))))

(provide 'markdown-bullets)
;;; markdown-bullets.el ends here

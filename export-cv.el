;;; export-cv.el --- Batch export Org CVs to AwesomeCV -*- lexical-binding: t; -*-

;; Author: Your Name
;; Created: 2025-11-11
;; Version: 0.3
;; Keywords: org, latex, cv, awesomecv, batch

;;; Commentary:
;;
;; Usage:
;;   emacs --batch -Q --load export-cv.el           # export all cv/*.org
;;   emacs --batch -Q --load export-cv.el file.org  # export one file
;;
;; Exports each Org file using the AwesomeCV backend to:
;;   <root>/src/<name>.tex
;;
;; Features:
;; - Finds project root via .git
;; - Loads AwesomeCV backend from lib/org-cv
;; - Ensures secrets.org and src/ exist
;; - Cross-platform (Linux, macOS, Windows)

;;; Code:

(require 'org)

(defun find-git-root (dir)
  "Return the Git root directory from DIR, or nil if not found."
  (let ((parent (locate-dominating-file dir ".git")))
    (and parent (expand-file-name parent))))

(defvar root-dir
  (or (find-git-root default-directory)
      default-directory)
  "Root directory of the project (the .git root).")

;; Add AwesomeCV backend from submodule
(let ((ox-awesomecv-path (expand-file-name "lib/org-cv" root-dir)))
  (add-to-list 'load-path ox-awesomecv-path)
  (require 'ox-awesomecv))

(defun ensure-file-exists (file)
  "Create FILE if it does not already exist."
  (unless (file-exists-p file)
    (with-temp-buffer (write-file file))))

(defun export-one-cv (org-file)
  "Export a single ORG-FILE to AwesomeCV LaTeX into <root>/src/."
  (let* ((src-dir (expand-file-name "src" root-dir))
         (output-file (expand-file-name
                       (concat (file-name-base org-file) ".tex")
                       src-dir)))
    (unless (file-directory-p src-dir)
      (make-directory src-dir t))
    (message "Exporting %s → %s" org-file output-file)
    (with-current-buffer (find-file-noselect org-file)
      (let ((exported (org-export-as 'awesomecv nil nil nil nil)))
        (with-temp-buffer
          (insert exported)
          (write-file output-file))))))

;; --- Main logic ---
(let* ((cv-dir (expand-file-name "cv" root-dir))
       (secrets-file (expand-file-name "secrets" cv-dir)))
  (ensure-file-exists secrets-file)

  (if command-line-args-left
      ;; Export only the given file
      (let ((org-file (expand-file-name (pop command-line-args-left) root-dir)))
        (export-one-cv org-file))
    ;; Export all cv/*.org files
    (let ((org-files (directory-files cv-dir t "\\.org\\'")))
      (if (null org-files)
          (message "No .org files found in %s" cv-dir)
        (dolist (org-file org-files)
          (export-one-cv org-file))))))

(message "CV export(s) complete.")

;;; export-cv.el ends here

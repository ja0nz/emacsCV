%===============================================================================
% awesome-cv-additions.cls
%
% Purpose:
%   Provides custom macros and overrides for the Awesome-CV class without
%   modifying the upstream awesome-cv.cls. This file is intended to be
%   concatenated with the original class at build time.
%===============================================================================


%-------------------------------------------------------------------------------
%                Configuration for links
%-------------------------------------------------------------------------------

% The \colorizelinks command enables URL colorization. Optional
% argument specifies the color.
\newcommand*{\colorizelinks}[1][awesome-skyblue]{%
  \hypersetup{%
    colorlinks=true,
    urlcolor=#1,
    linkcolor=#1,
    citecolor=#1
}}{}

% The \underlinelinks command enables URL underlining. Optional
% argument specifies the underline color.
\newcommand*{\underlinelinks}[1][awesome-skyblue]{%
  \LetLtxMacro{\savedhref}{\href}%
  \renewcommand{\href}[2]{\savedhref{##1}{\setulcolor{#1}\ul{##2}}}}

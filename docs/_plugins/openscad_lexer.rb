# frozen_string_literal: true

# Rouge lexer for the OpenSCAD language (https://openscad.org).
#
# Registered from docs/_plugins/ so that ```scad and ```openscad fenced code
# blocks are syntax-highlighted. Rouge ships no OpenSCAD lexer, and this repo
# builds with a full `jekyll build` in GitHub Actions (not the restricted
# GitHub Pages gem whitelist), so a custom Rouge lexer loads normally.
require "rouge"

module Rouge
  module Lexers
    class OpenSCAD < RegexLexer
      title "OpenSCAD"
      desc "The OpenSCAD language for solid 3D CAD modelling (openscad.org)"
      tag "openscad"
      aliases "scad"
      filenames "*.scad"
      mimetypes "application/x-openscad", "text/x-openscad"

      def self.keywords
        @keywords ||= Set.new %w[module function if else for let each use include]
      end

      def self.constants
        @constants ||= Set.new %w[true false undef PI]
      end

      def self.builtins
        @builtins ||= Set.new %w[
          cube sphere cylinder polyhedron square circle polygon text
          translate rotate scale resize mirror multmatrix color offset
          hull minkowski union difference intersection render children
          linear_extrude rotate_extrude projection surface import group
          echo assert
          abs sign sin cos tan acos asin atan atan2 floor round ceil
          ln len log pow sqrt exp rands min max norm cross concat lookup
          str chr ord search version version_num parent_module
          is_undef is_list is_num is_bool is_string is_function
        ]
      end

      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        # use <library> / include <library>
        rule %r/\b(use|include)\b(\s*)(<[^>\n]*>)/ do |m|
          groups Keyword::Namespace, Text::Whitespace, Str::Other
        end

        rule %r/"/, Str::Double, :string

        # special variables: $fn, $fa, $fs, $t, $vpr, $preview, $children, ...
        rule %r/\$[a-zA-Z_]\w*/, Name::Variable::Magic

        # numbers
        rule %r/[0-9]+\.[0-9]*(?:[eE][+-]?[0-9]+)?/, Num::Float
        rule %r/\.[0-9]+(?:[eE][+-]?[0-9]+)?/, Num::Float
        rule %r/[0-9]+[eE][+-]?[0-9]+/, Num::Float
        rule %r/[0-9]+/, Num::Integer

        # identifiers used as a call: name(  -> keyword / builtin / function
        rule %r/[a-zA-Z_]\w*(?=\s*\()/ do |m|
          name = m[0]
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.builtins.include?(name)
            token Name::Builtin
          else
            token Name::Function
          end
        end

        # bare identifiers -> keyword / constant / builtin / name
        rule %r/[a-zA-Z_]\w*/ do |m|
          name = m[0]
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.constants.include?(name)
            token Keyword::Constant
          elsif self.class.builtins.include?(name)
            token Name::Builtin
          else
            token Name
          end
        end

        rule %r/[{}()\[\];,.]/, Punctuation
        rule %r/[+\-*\/%<>=!&|?:#]+/, Operator
      end

      state :string do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end

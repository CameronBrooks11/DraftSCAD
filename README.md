# DraftSCAD

OpenSCAD is an open-source program used to create 3D objects. Part of its appeal stems from its text-based input, which specifies the objects, placement, rotation, and other features. Unlike some other 3D programs, such as Blender, OpenSCAD provides precise, programmatic control over the characteristics of objects, enabling a streamlined design process without the need for manual adjustments on-screen.

However, creating manual machining equipment or workshop-ready parts often requires detailed, annotated engineering drawings—a capability that OpenSCAD does not natively provide. Furthermore, OpenSCAD's mesh-based output complicates the process of exporting designs to traditional CAD programs for annotation, even as a workaround. This limitation makes it challenging to bridge the gap between OpenSCAD's programmatic design strengths and the practical requirements of fabrication workflows. To address this, the utility library aims to enable the creation of dimensioned drawings directly within OpenSCAD, streamlining the process for designers who rely on this tool.

<img src="images/example_CM.png" alt="Canny Machines Example" height="400"><img src="images/example_DS.png" alt="Don Smiley Example" height="400">

## Approach

This library employs a top-down view in OpenSCAD, with dimensioned lines and text displayed on the XY plane. By combining multiple views of your object with projected and translated dimensioned lines, you can create the illusion of a complete dimensioned drawing.

A number of elements must come together to implement dimensioning:

- Lines, with or without arrows.
- Annotated dimensions and other textual descriptions.
- Support for common annotation conventions.

The library includes a partial implementation of these features, making it functional yet extensible for future improvements.

To get started, explore the [documentation](docs/README.md) and the [examples](examples/README.md). Quick-start guides and further simplifications are planned for future releases.

## Contributing

Contributions are welcome! Whether it's bug fixes, new features, or documentation improvements, your input helps make this project better. If you're interested in contributing, please check out the [TODO](docs/TODO.md) file for a list of development tasks and areas where help is needed. If you have suggestions or ideas that aren't listed, don't hesitate to open an issue to discuss them.

## Acknowledgements

This repository builds upon the work of:

- Don Smiley from [Canny Machines](http://cannymachines.com/entries/9/openscad_dimensioned_drawings).
- pwpearson's enhancements on Canny Machines: [dimensional-drawings](https://github.com/pwpearson/dimensional-drawings).

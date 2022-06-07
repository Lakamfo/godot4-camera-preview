# Nefrace's Camera Preview plugin, rework for Godot Engine 4 by Lakamfo

![icon](https://user-images.githubusercontent.com/18103556/172068287-a90cc657-ee91-4fec-b843-e4c2f7c44290.png)

Allows you to add a small preview window outside main editor's view to show the preview of the selected camera.

It can search through the children of selected node to find a Camera node (disabled by default)

## Installation

- Clone this repo inside "addons" folder of your project
- Enable it from "Plugins" section inside Project Settings
- Go to 3D view and toggle option "Visible" inside "Camera preview" menu on the toolbar
- enjoy!

## Node search modes

There's 3 search modes that can help to find a Camera node in the children of the selected node:

- **Disabled** - only selected node is checked
- **By name** - uses `find_node` method with defined search mask (_"Camera*"_ by default)
- **By class** - recursively checking all children for type **Camera** (Not tested well, may not work with instantiated packed scenes)


https://user-images.githubusercontent.com/49194161/172311277-0a6650f9-cd6d-45de-a2cc-1dd123c780bc.mp4


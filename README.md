# MFSE
MicroFossil Segmentation Editor Manual

# Introduction

# General notes

The basic shell segmentation cannot be edited with MFSE.

A label consisting of with very few voxels

Label operations are generally irreversible

[Introduction](#_Toc216261966)

[General notes](#_Toc216261967)

[Glossary](#_Toc216261968)

[Toolbar Menu](#_Toc216261969)

[File](#_Toc216261970)

[Import](#_Toc216261971)

[Macros](#_Toc216261972)

[Export](#_Toc216261973)

[Preferences](#_Toc216261974)

[Help](#_Toc216261975)

[GUI](#_Toc216261976)

[Segmentation project information panel](#_Toc216261977)

[View and select panel](#_Toc216261978)

[Camera controls](#_Toc216261979)

[3D environment visualization panel](#_Toc216261980)

[Basic shell segmentation panel](#_Toc216261981)

[General label operations panel](#_Toc216261982)

[Lumen label operations panel](#_Toc216261983)

[Shell label operations panel](#_Toc216261984)

[Label data panel](#_Toc216261985)

[Hotkeys](#_Toc216261986)

[Project Creation Tool](#_Toc216261987)

# Glossary

**_Voxel_** - is a three-dimensional equivalent to a pixel. It represents the value for a (in our case always cubic) regularly sized and spaced portion of a data volume. For the purpose of volume segmentation in MFSE each voxel in each layer either belongs to a label (is set) or represents empty space in your volume (is not set).

**_Layer_** - is a three-dimensional volume in which the voxels of your segmentation project data exist. A project can contain several layers; currently the maximum number of layers is set to four.

Patch - is a group of voxels that belong to the same label in the same layer and are connected in 18-connectivity. A patch can consist of a single voxel. The user cannot interact with an individual patch.

Label - is a group of voxels that are treated for the purposes of label operations, display, and organization. A label exists in exactly one layer but can consist of several unconnected patches and is the element the user can manipulate directly.

Class - is an obligate Label property. Currently four types of Class are recognized: _Unclassified_ (default), _Lumen_, _Shell_, and _Externa_. The assigned class of label has consequences for the available label operations and its behavior in certain label operations.

Morphounit - are a descriptive property that is to be used for the enumeration of the successive growth stages of a microfossil (i.e. foraminifera). Multiple labels of different classes can belong to one morphounit.

_Volume constant label operations_ - do neither add nor remove set voxels from your segmentation project. They only change the label associations of set voxels.

Lumen (class)- is (in regard to this software) the inside space of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as lumen are permitted to coexist with voxel set in the basic shell segmentation, that is the lumen of a microfossil cannot expand into the shell.

Shell (class)- is (in regard to this software) the inside space of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as lumen are permitted to coexist with voxel set in the basic shell segmentation, that is the lumen of a microfossil cannot expand into the shell.

Externa (class)- is (in regard to this software) the inside space of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as lumen are permitted to coexist with voxel set in the basic shell segmentation, that is the lumen of a microfossil cannot expand into the shell.

# Toolbar Menu

## File

#### Open project creation tool

This menu item opens the Project Creation Tool. This tool will allow you to create a segmentation project and MSD file. The usage of the Project Creation Tool is described in the respective chapter of this manual

#### Load project

Loads a previously created or saved segmentation project file (MSD file format).

#### Save project

Saves your current segmentation project file (MSD file format). A dialogue will open and asks for the file name.

#### Revert project

XXX

## Import

#### External ambient occlusion data

Imports ambient occlusion data from an external source (e.g. from AMIRA). This data can then be used in the _Delimit_ operation, saving MFSE from calculation the ambient occlusion which is currently a very time intensive operation.

#### Legacy MSD file

XXX

## Macros

#### Finalize shell layer

This macro assigns any shell voxels not yet labeled to a set of new labels according to their vicinity to any labeled primary shells.

## Export

#### Export RAW

Exports the current project as a RAW binary. The voxel data of all layers is exported, the volume dimensions, voxelsize and data encoding is appended to the project name and suggested in the dialog that opens and asks for the file name.

#### Export GIPL

Exports the current project as a GIPL file. A dialog opens to select the layer to be exported. A text file with the label descriptions is created alongside. This file can be imported into ITK-snap and will not only contain the label names but also the colormap and label visibility of the segmentation project at the time of export. The text file essentially recreates the current view of MFSE in ITK-Snap.

## Preferences

Opens a window where certain processing and display parameters can be altered

#### Parallel computing

All options for the use of a parallel pool. Parallel computing is used as standard (if available) for many of the more complex calculations such as the generation of ambient occlusion fields.

#### Lighting

This panel contains all lighting option. After changes have been made all patch will need to be regenerated.

#### Label operation defaults

This panel contains all the options for default parameter values for any kind of label operation.

#### Label table optional properties

This table contains all the available parameters in different units shown in the label data table of the GUI. This list is likely to change with future versions of MFSE.

## Help

#### About

Shows the current version and additional information on MFSE.

#### Show Manual

Opens this Manual.

#### Show Tutorials

Opens the Tutorial file, which will give you a Step-by-Step guide through the basic segmentation of a supplied example data file.

# GUI

The GUI is subdivided into several regions and panels.

## Segmentation project information panel

This panel will present the basic segmentation project information, including:

**Name** - Name of the segmentation project

**Voxelsize \[µm\]** - Voxelsize/Resolution of the underlying scan data in µm

**Dimensions \[X Y Z ; vx\]** - X/Y/Z - Dimensions of the underlying scan data in voxels

**Basic shell source** - Source file of the basic shell segmentation

**Primary label source** - Source (file) of the primary label data

**Labels** - shows the number of unique labels in this project

**Active** - shows the number of active labels in this project

**Layers** - shows the number of layers in this project

**Morphounits** - shows the number of morphounits in this project

**Classes** - shows the number of classes in this project

**Groups** - shows the number of groups in this project

**Types** - shows the number of types in this project

**Comment** - allows you to enter any comment, e.g. to memorize the label you are currently working on, notes about the specimen, etc.

## View and select panel

This section covers basic selection and visibility options of the labels, as well as a possibility to display and visually modify the underlying, imported basic shell segmentation.

#### View/Select

This button allows you to toggle between the **View** and **Select** tool.  
The **View** tool option allows these basic operations: Rotate the view by pressing the Middle Mouse Button and the moving your cursor. The view remains centered on the object. Stop moving by clicking the Left Mouse Button. Zoom in/out with your Mouse Scroll Wheel.  
The **Select** tool option allows these basic operations: Select/Unselect certain labels by clicking them with the Left Mouse Button. Holding shift while selecting labels by pointer allows the selection of several labels. Clicking on a selected label will deselect all currently selected labels. Holding shift while clicking on a selected label will only deselect the clicked label and retain the remaining current selection of labels.

#### Label selection

This field shows the label numbers of the currently selected labels.

#### Select visible

Select all visible labels. The visible property can be set in the Label data table.

#### Invert selection

XXX

#### Show

XXX

#### Hide

XXX

#### .. only

XXX

#### .. active

XXX

#### Show all

Shows all labels.

#### Hide all

Hides all labels.

#### Show only selection

Shows only currently selected label(s).

#### Show in vicinity

After selecting a single label this allows you selectively show only labels that have their centroid located in a defined distance <= X voxels to the selected label. A dialog opens that asks for the distance value to use. This distance value used for selectively showing labels is independently calculated from the Distance entry in "Label data" table in the Label data panel.

#### Label filter

XXX

## Camera controls

In addition to cursor-controlled camera control in the visualization panel, this panel allows you to manually control the camera of the visualization with the following options:

#### Roll left/right

#### Tilt up/down

#### Tilt left/right

#### Zoom in/out

## 3D environment visualization panel

#### Frame Show

Toggles the visibility of the 3D frame.

#### Frame Color

A dialog window will open that allows to choose the color of the background of the 3D frame.

#### Axes Show

Toggles the visibility of the 3D axes.

#### Axes Color

A dialog window will open that allows to choose the color of the 3D axes.

#### Axis labels Show

Toggles the visibility of the 3D axes labels.

#### Grid Show

Toggles the visibility of the 3D grid.

## Basic shell segmentation panel

**Note: the basic shell segmentation CANNOT be edited in MFSE.**

#### Show

Toggles the visibility of basic shell segmentation patch.

#### Color

A dialog window will open that allows to choose the color of the basic shell segmentation patch.

#### Opacity

A slider that changes the opacity of the basic shell segmentation patch.

All label operations can be performed from the following panels, which are divided to General, Lumen and Shell label operations.

## General label operations panel

This panel includes all the available operations for the editing process of the labels regardless of class.

#### Combine

Combines the selected labels in a volume constant operation. To execute this operation, a minimum of two labels needs to be selected. These labels have to be connected in an 18-connectivity 3D neighborhood and must exist in the same layer. A dialogue window will ask for the name of the new label.

#### Divide

Splits the selected singular label into a number of desired subvolumes posing as new labels in a volume constant operation. A dialog opens that asks for the number of desired subvolumes. When this label operation is applied, MFSE will automatically name the newly generated labels with "split patch NX", where X represents a consecutive numbering of the newly generated labels. To execute this operation, one label needs to be selected which consists of only one patch.

#### Singularize

Removes all but the largest patch of non-singular labels. The removed patches are deleted. To execute this operation, one or multiple labels need to be selected but each label must consist of multiple patches.

#### Separate patches

Separates patches based on their individual volumes. A dialog opens that asks for the minimum volume and minimum solidity of patches to separate. These two thresholds will be combindes. Labels below the combinded threshold will not be separated. MFSE will automatically name the resulting labels with "subpatch NX" respectively, where X represents a consecutive numbering of the newly generated labels. To execute this operation, one or multiple labels need to be selected which consist of multiple patches.

#### Transfer

Moves the selected label(s) to a different layer. A dialog opens and asks for the destination layer. Label voxels in the destination layer will be overwritten by the moved labels. To execute this operation, one or multiple labels need to be selected.  
**WARNING Voxels in the target layer are overwritten without checking whether they already belonging to another label.**

Copy  
Copies the selected label(s) to a different layer. A dialog opens and asks for the name of the new label and the destination layer. Label voxels in the destination layer will be overwritten by the moved labels. To execute this operation, one or multiple labels need to be selected.  
**WARNING Voxels in the target layer are overwritten without checking whether they already belonging to another label.**

#### Recolor

Recolors the selected label(s) by assigning a random color from the chosen color spectrum in the Label data panel. To execute this operation, one or multiple labels need to be selected.

#### Recenter

This function sets the centroid of your currently selected label as the center for all distance calculations and recalculates the distance property for all labels.

#### Delete

Deletes the selected label permanently from the harboring label field. To execute this operation, one or multiple labels need to be selected. A dialogue window will ask for confirmation.

#### Merge

Merges exactly two selected labels into one. The labels do not need to be connected but must exist in the same layer. Voxel will be added to connect the two selected labels in 18-connectivity 3D neighborhood.

#### Split

Splits the selected label (which must consist of only one patch) into a number of desired subvolumes, voxels are lost. A dialog opens that asks for the number of desired subvolumes. When this label operation is applied, MFSE will automatically denominate the resulting labels with "split patch NX" respectively. To execute this operation, one label needs to be selected which consists of only one patch.

#### Subtract

A dialogue window will open that asks for the name of the new label, the destination layer and which of selected the labels are to be used as minuend and subtrahend. To execute this operation, two labels need to be selected.  
**WARNING Voxels in the target layer are overwritten without checking whether they already belonging to another label.**

#### Intersect

XXX. To execute this operation, two labels need to be selected.

#### Remove appendages

Removes appendages via an image closing algorithm. A dialog opens that asks for the reduction factor. The volume is expanded and subsequently eroded by sphere with the radius of the reduction factor. This operation smooths the outline of the volume and removes small appendages. When this label operation is applied, MFSE will create a new label containing the removed volume and automatically name it by the original name followed by "appendage". To execute this operation, one or multiple labels need to be selected.

## Lumen label operations panel

This panel includes all the available operations for the editing process of lumen labels. This panel is only accessible after at least one label is classified as Lumen.

#### Delimit in situ

Delimit the extent of selected label by finding a threshold value in the ambient occlusion data that maximizes the volume to surface ratio. A dialog opens that asks you to enter the margin width for the calculation of the ambient occlusion field, the number of rays, the expansion factor for the volume, additional labels to consider and the target layer.

When this label operation is applied, MFSE will automatically denominate the externa with "externa".

To execute this operation, one label with the class lumen needs to be selected.

#### Delimit concave in vivo

xxx

A dialog opens that asks you to enter the margin width for the calculation of the ambient occlusion field, the number of rays, the expansion factor for the volume, the shell, lumen labels and morphounits to consider, the target layer and which label to add the anterior appendage to.

To execute this operation, one label needs to be selected with Class set to Lumen. MU too?

#### Trace chamber wall

Trace the primary chamber wall of the selected label(s).

To execute this operation, one or multiple labels need to be selected. Each label needs to have an assigned MU and Class set to Lumen.

## Shell label operations panel

#### Delimit convex individual

Creates a theoretical lumen within the hull of the selected shell label. A dialog opens that asks you to enter the name of the new label, the reduction element radius, whether you want to remove the lower growth stage lumina, the lumen layer to consider and the target layer.

To execute this operation, one label needs to be selected. Each label needs to have an assigned MU and Class set to Shell.

## Label data panel

#### Relabel

This tool will renumber every label in the project according the current order in the label data table. This also assigns new colors to each label.

#### Recolor

This tool allows you to recolor the entirety of label patches in this project. The adjacent dropdown menu lets you choose a color palette of _Lines_, _Colorbrewer_, _Prism,_ and _HSV_.

#### Sort

This allows you to perform a customized sorting of the table item according to the sorting parameter (selection box) and sorting order (radio buttons) next to the button.

#### Filter parameter

This allows you to filter the labels by certain parameters. The Drop-Down-Menu lets you choose which parameter you want to filter. The following two buttons allow you to enter a minimum and maximum value for your selected parameter. You can apply the filter by clicking the Filter-button. The filter will deactivate all labels not matching the filter criteria.

#### Force visualization

This allows you to force a visualization method from the adjacent dropdown menu with the options of: _Voxels_, _Normal_, and _Smoothed._

#### Label information table

This table provides you with all the necessary information about the labels.

Label(editable via label operation) This column shows the label numbers. These are automatically assigned when your segmentation data file is created.

Active(manually editable) Any label which might not be relevant to your segmentation project's goal can be set to inactive to facilitate the overview of your work. This column shows which labels are currently active/inactive. Status can be changed by ticking the respective checkboxes. Labels set to inactive are also set to not visible. Inactive labels are **ignored** for all label operations (e.g. delimit).

Visible(manually editable) This column sets the visibility status in the visualization for each label. The status can be changed by ticking/unticking the respective checkboxes.

Layer(editable via label operations) This column shows the layer in which the label is stored.

MU(manually editable) This column shows the morphounit assigned to the label.

NameThis column allows you to apply an individual description to the label.

ClassThe first hierarchical level of label description. Currently four types are distinguished and can be set: Unclassified, Lumen, Shell and Externa.

GroupThe second hierarchical level of label description. The user is free to use any categorization.

TypeThe third hierarchical level of label description. The user is free to use any categorization.

Visu(alization)This Drop-Down-Menu allows you to modify the visualization of individual labels. There are three options: normal, smoothed, voxels. Please note that the voxelized visualization requires significantly more performance from your PC, so it should be employed sparingly.

PatchesThis column shows you how many patches (spatially separated subvolumes, 18- connectivity) a certain label consists of.

Volume \[vx\]This column shows you the volume of each label, which is the actual number of voxels within the label, returned as a scalar.

1st axis **\[vx\]**

???

#### Solidity

This column shows you the proportion of the _MATLAB - Proportion of the voxels in the convex hull that are also in the region, returned as a scalar. Computed as Volume/ConvexVolume._

**Extent**

This column shows you the ratio of voxels within the label to voxels in the total bounding box, which is the smallest cuboid containing the label.

_MATLAB - Ratio of voxels in the region to voxels in the total bounding box, returned as a scalar. Computed as the value of Volume divided by the volume of the bounding box. \[Volume/(bounding box width \* bounding box height \* bounding box depth)\]_

**Distance \[vx\]**

This column shows you the distance of each label to one selected label. This selection can be made by using the "Recenter" tool. The distance is measured from each chamber lumen's centroid.

# Hotkeys

#### Delete

#### **_Show/Hide selected label_**(s)

# Project Creation Tool

The Project Creation tool will require you to input a set of project data in order to create your project.

There are 3 main panels on the right side.

The top panel PREVIEW Segmentation project information will display the basic project information, after inputting it in the Project data panel.

The second panel Display will allow you to select, whether the preview panel on the left should display your Basic shell segmentation or Primary chamber labels, once input.

The input required to create your project is listed in the panel Project data. This panel is divided into Mandatory input and Optional input**.**

Each input is accompanied by a checkbox, which will either automatically confirm a correct data input or will need the user's validation.

The Mandatory input requires:

#### Project name

In this section, you Project name can be modified. This will not have to be filled out manually, if the Project information is input via GIPL or header.

#### Project information

Furthermore, Project information will have to be entered. This can be done manually, from a GIPL file or from a header. Upon entering this data, a preview of the information will be shown in the top-right panel "PREVIEW Segmentation project information".

#### Shell segmentation

After this, you will need to input the **Shell** data. This can be done from a GIPL or a RAW file. When the data is input, the large panel on the left will allow you to preview and scroll through the cross-section. This data needs to be validated manually, using the "Validate" button, to proceed with the Project creation.

If not continue processing your shell segmentation in the software of your choice.

#### Lumen labels

Lastly, Lumen labels are required. For this, you can either use a previous output (e.g. from Amira) and input a GIPL or RAW file, if available, or MFSE will be able to create your own chamber segmentation, using a distance map. This data will also be previewed in the left panel and will have to be validated.

The Optional input includes:

Label description This gives you the opportunity to import a pre-made label description (e.g. from an ITK-Snap TXT file).

In case any input was wrong, you have the option to use the Clear project button to clear all input data from the project.

Upon entering all of this data and validating it, you will be able to create your segmentation project and MSD file by using the **Create project** button below.

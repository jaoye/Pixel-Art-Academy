LOI = LandsOfIllusions

_.extend LOI.Character.Part.Types,
  Body: new LOI.Character.Part
    type: 'Body'
    name: 'body'
    properties:
      arms: new LOI.Character.Part.Property.OneOf
        name: 'arms'
        type: 'Arms'
      torso: new LOI.Character.Part.Property.OneOf
        name: 'torso'
        type: 'Torso'
      head: new LOI.Character.Part.Property.OneOf
        name: 'head'
        type: 'Head'
      legs: new LOI.Character.Part.Property.OneOf
        name: 'legs'
        type: 'Legs'
      skin: new LOI.Character.Part.Property.Color
        name: 'skin'
        colorsPresetName: 'Skin'
    renderer: new LOI.Character.Part.Renderers.Body
      origin:
        landmark: 'navel'

  Head: new LOI.Character.Part
    type: 'Head'
    name: 'head'
    properties:
      neck: new LOI.Character.Part.Property.OneOf
        name: 'neck'
        type: 'Neck'
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'HeadShape'
    renderer: new LOI.Character.Part.Renderers.Default
      origin:
        landmark: 'atlas'

  HeadShape: new LOI.Character.Part.SkinShape
    type: 'HeadShape'
    name: 'head shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'atlas'
    landmarks:
      atlas: new LOI.Character.Part.Landmark.Position
        name: 'atlas'

  Neck: new LOI.Character.Part
    type: 'Neck'
    name: 'neck'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'NeckShape'

  NeckShape: new LOI.Character.Part.SkinShape
    type: 'NeckShape'
    name: 'neck shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'atlas'
        x: 0
        y: -1
    landmarks:
      atlas: new LOI.Character.Part.Landmark.Position
        name: 'atlas'
      suprasternalNotch: new LOI.Character.Part.Landmark.Position
        name: 'suprasternalNotch'

  Torso: new LOI.Character.Part
    type: 'Torso'
    name: 'torso'
    renderer: new LOI.Character.Part.Renderers.Default
      origin:
        landmark: 'navel'
    properties:
      chest: new LOI.Character.Part.Property.OneOf
        name: 'chest'
        type: 'Chest'
      abdomen: new LOI.Character.Part.Property.OneOf
        name: 'abdomen'
        type: 'Abdomen'
      groin: new LOI.Character.Part.Property.OneOf
        name: 'groin'
        type: 'Groin'

  Chest: new LOI.Character.Part
    type: 'Chest'
    name: 'chest'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'ChestShape'
      modifications: new LOI.Character.Part.Property.Array
        name: 'additions'
        types: ['ChestBodyFat', 'ChestMuscles', 'Breasts']

  ChestShape: new LOI.Character.Part.SkinShape
    type: 'ChestShape'
    name: 'chest shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'xiphoid'
        x: 0
        y: 3.5
    landmarks:
      xiphoid: new LOI.Character.Part.Landmark.Position
        name: 'xiphoid'
      suprasternalNotch: new LOI.Character.Part.Landmark.Position
        name: 'suprasternalNotch'
      shoulderLeft: new LOI.Character.Part.Landmark.Position
        name: 'shoulderLeft'
      shoulderRight: new LOI.Character.Part.Landmark.Position
        name: 'shoulderRight'

  ChestBodyFat: new LOI.Character.Part.SkinShape
    type: 'ChestBodyFat'
    name: 'chest body fat'

  ChestMuscles: new LOI.Character.Part.SkinShape
    type: 'ChestMuscles'
    name: 'chest muscles'

  Breasts: new LOI.Character.Part
    type: 'Breasts'
    name: 'breasts'
    properties:
      positionX: new LOI.Character.Part.Property.Integer
        name: 'horizontal position'
        min: -2
        max: 2
      positionY: new LOI.Character.Part.Property.Integer
        name: 'vertical position'
      scaleX: new LOI.Character.Part.Property.Integer
        name: 'horizontal size'
      scaleY: new LOI.Character.Part.Property.Integer
        name: 'vertical size'
      nippleX: new LOI.Character.Part.Property.Integer
        name: 'horizontal position of nipples'
      nippleY: new LOI.Character.Part.Property.Integer
        name: 'vertical position of nipples'
      nippleShade: new LOI.Character.Part.Property.RelativeColorShade
        name: 'shade of nipples'
        baseColor: (hierarchy) ->
          bodyNode = hierarchy.ancestorNodeWith (node) -> node.type is 'Body'
          bodyNode.properties.skin
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'BreastsShape'
    landmarks:
      nipplePosition: new LOI.Character.Part.Landmark.Position
      outerEdgePosition: new LOI.Character.Part.Landmark.Position
      bottomEdgePosition: new LOI.Character.Part.Landmark.Position

  BreastsShape: new LOI.Character.Part
    type: 'BreastsShape'
    name: 'breasts shape'
    properties:
      topShape: new LOI.Character.Part.Property.OneOf
        name: 'top shape'
        type: 'BreastsShapeTop'
      bottomShape: new LOI.Character.Part.Property.OneOf
        name: 'bottom shape'
        type: 'BreastsShapeBottom'
    landmarks:
      centerPosition: new LOI.Character.Part.Landmark.Position
      edgePosition: new LOI.Character.Part.Landmark.Position

  BreastsShapeTop: new LOI.Character.Part.SkinShape
    type: 'BreastsShapeTop'
    name: 'breasts shape top'
    landmarks:
      centerPosition: new LOI.Character.Part.Landmark.Position
      edgePosition: new LOI.Character.Part.Landmark.Position

  BreastsShapeBottom: new LOI.Character.Part.SkinShape
    type: 'BreastsShapeBottom'
    name: 'breasts shape bottom'
    landmarks:
      centerPosition: new LOI.Character.Part.Landmark.Position
      edgePosition: new LOI.Character.Part.Landmark.Position

  Abdomen: new LOI.Character.Part
    type: 'Abdomen'
    name: 'abdomen'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'AbdomenShape'

  AbdomenShape: new LOI.Character.Part.SkinShape
    type: 'AbdomenShape'
    name: 'abdomen shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'navel'
    landmarks:
      xiphoid: new LOI.Character.Part.Landmark.Position
        name: 'xiphoid'
      navel: new LOI.Character.Part.Landmark.Position
        name: 'navel'
      hypogastrium: new LOI.Character.Part.Landmark.Position
        name: 'hypogastrium'

  Groin: new LOI.Character.Part
    type: 'Groin'
    name: 'groin'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'GroinShape'

  GroinShape: new LOI.Character.Part.SkinShape
    type: 'GroinShape'
    name: 'groin shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'hypogastrium'
        x: 0
        y: -2.5
    landmarks:
      navel: new LOI.Character.Part.Landmark.Position
        name: 'navel'
      acetabulumLeft: new LOI.Character.Part.Landmark.Position
        name: 'acetabulumLeft'
      acetabulumRight: new LOI.Character.Part.Landmark.Position
        name: 'acetabulumRight'

  Arms: new LOI.Character.Part
    type: 'Arms'
    name: 'arms'
    properties:
      upperArm: new LOI.Character.Part.Property.OneOf
        name: 'upper arm'
        type: 'UpperArm'
      lowerArm: new LOI.Character.Part.Property.OneOf
        name: 'lower arm'
        type: 'LowerArm'
      hand: new LOI.Character.Part.Property.OneOf
        name: 'hand'
        type: 'Hand'
    renderer: new LOI.Character.Part.Renderers.Default
      origin:
        landmark: 'elbow'

  UpperArm: new LOI.Character.Part
    type: 'UpperArm'
    name: 'upper arm'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'UpperArmShape'

  UpperArmShape: new LOI.Character.Part.SkinShape
    type: 'UpperArmShape'
    name: 'upper arm shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'elbow'
        x: 0
        y: 3
    landmarks:
      shoulder: new LOI.Character.Part.Landmark.Position
        name: 'shoulder'
      elbow: new LOI.Character.Part.Landmark.Position
        name: 'elbow'

  LowerArm: new LOI.Character.Part
    type: 'LowerArm'
    name: 'lower arm'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'LowerArmShape'

  LowerArmShape: new LOI.Character.Part.SkinShape
    type: 'LowerArmShape'
    name: 'lower arm shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'elbow'
        x: 0
        y: -6
    landmarks:
      elbow: new LOI.Character.Part.Landmark.Position
        name: 'elbow'
      wrist: new LOI.Character.Part.Landmark.Position
        name: 'wrist'

  Hand: new LOI.Character.Part
    type: 'Hand'
    name: 'hand'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'HandShape'

  HandShape: new LOI.Character.Part.SkinShape
    type: 'HandShape'
    name: 'hand shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'wrist'
        x: 0
        y: -1
    landmarks:
      wrist: new LOI.Character.Part.Landmark.Position
        name: 'wrist'

  Legs: new LOI.Character.Part
    type: 'Legs'
    name: 'legs'
    properties:
      foot: new LOI.Character.Part.Property.OneOf
        name: 'foot'
        type: 'Foot'
      lowerLeg: new LOI.Character.Part.Property.OneOf
        name: 'lower leg'
        type: 'LowerLeg'
      thigh: new LOI.Character.Part.Property.OneOf
        name: 'thigh'
        type: 'Thigh'
    renderer: new LOI.Character.Part.Renderers.Default
      origin:
        landmark: 'knee'

  Thigh: new LOI.Character.Part
    type: 'Thigh'
    name: 'thigh'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'ThighShape'

  ThighShape: new LOI.Character.Part.SkinShape
    type: 'ThighShape'
    name: 'thigh shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'acetabulumLeft'
        x: 0
        y: -7
    landmarks:
      acetabulum: new LOI.Character.Part.Landmark.Position
        name: 'acetabulum'
      knee: new LOI.Character.Part.Landmark.Position
        name: 'knee'

  LowerLeg: new LOI.Character.Part
    type: 'LowerLeg'
    name: 'lower leg'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'LowerLegShape'

  LowerLegShape: new LOI.Character.Part.SkinShape
    type: 'LowerLegShape'
    name: 'lower leg shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'knee'
        x: 0
        y: -6
    landmarks:
      knee: new LOI.Character.Part.Landmark.Position
        name: 'knee'
      ankle: new LOI.Character.Part.Landmark.Position
        name: 'ankle'

  Foot: new LOI.Character.Part
    type: 'Foot'
    name: 'foot'
    properties:
      shape: new LOI.Character.Part.Property.OneOf
        name: 'shape'
        type: 'FootShape'

  FootShape: new LOI.Character.Part.SkinShape
    type: 'FootShape'
    name: 'foot shape'
    renderer: new LOI.Character.Part.Renderers.Shape
      origin:
        landmark: 'ankle'
        x: 0
        y: -1
    landmarks:
      ankle: new LOI.Character.Part.Landmark.Position
        name: 'ankle'
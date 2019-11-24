import SceneKit


class Node: SCNNode {
 required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 

 init(vertexNumber: String) {
  super.init()
  
  name = vertexNumber
  
  let text = SCNText(string: vertexNumber, extrusionDepth: 0.0)
  text.firstMaterial?.diffuse.contents = UIColor.yellow
  scale = SCNVector3(0.0001, 0.0001, 0.0001) // Adjust this to make the numbers on the face larger

  geometry = text
 }
 
 
 func updatePosition(for vectors: [vector_float3]) {
  let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
  position = SCNVector3(newPos)
 }
 
 
}

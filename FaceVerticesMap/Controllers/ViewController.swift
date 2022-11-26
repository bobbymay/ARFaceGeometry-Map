import UIKit
import ARKit


class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
        sceneView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}


extension ViewController: ARSCNViewDelegate {
    
    /// Updates the positions of text (numbers) on face
    func update(for node: SCNNode, using anchor: ARFaceAnchor) {
        for n in 0...anchor.geometry.vertices.count - 1 {
            let child = node.childNode(withName: "\(n)", recursively: false) as? Node
            
            guard let number = child?.name, let vertex = Int(number) else { return }
            let vertices: [vector_float3] = [anchor.geometry.vertices[vertex]]
            
            child?.updatePosition(for: vertices)
        }
    }
    
    
    /// Called once when face is recognized. Adds text to face
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneView.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        //  faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        // Adds text to face
        for n in 0...faceAnchor.geometry.vertices.count {
            faceNode.addChildNode(Node(vertexNumber: "\(n)"))
        }
        
        update(for: faceNode, using: faceAnchor)
        return faceNode
    }
    
    
    /// Tracks face movement
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        update(for: node, using: faceAnchor)
    }
    
}



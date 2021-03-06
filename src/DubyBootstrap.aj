import java.util.ArrayList;
import java.util.List;
import mirah.lang.ast.Node;
import mirah.lang.ast.NodeScanner;
import mirah.lang.ast.NodeImpl;

/* To compile the new AST with duby extensions:
 * ajc -1.5 -inpath dist/mirah-parser.jar \
 *     -outjar dist/mirah-parser_with_duby.jar \
 *     -classpath ../mirah/javalib/mirah-bootstrap.jar:/Developer/aspectj1.6/lib/aspectjrt.jar \
 *     src/DubyBootstrap.aj
 */

class ChildCollector extends NodeScanner {
  private ArrayList<Node> children = new ArrayList<Node>();

  @Override
  public boolean enterDefault(Node node, Object arg) {
    if (node == arg) {
      return true;
    } else {
      children.add(node);
      return false;
    }
  }

  @Override
  public Object enterNullChild(Object arg){
    children.add(null);
    return null;
  }

  public ArrayList<Node> children() {
    return children;
  }
}

aspect DubyBootsrap {
  declare parents: Node extends duby.lang.compiler.Node;

  public List<Node> NodeImpl.child_nodes() {
    ChildCollector c = new ChildCollector();
    c.scan(this, this);
    return c.children();
  }
}
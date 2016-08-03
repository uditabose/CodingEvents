
package shapeways.others;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Udita <udita.bose@nyu.edu>
 */
public class LeafProductFinderTest {
    
    public LeafProductFinderTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of findLeaves method, of class LeafProductFinder.
     */
    @Test
    public void testFindLeaves() {
        System.out.println("findLeaves");
        List<ProductionOrder> allOrders = new ArrayList<>();
        
        ProductionOrder a = new ProductionOrder();
        a.id = 1;
        
        ProductionOrder f = new ProductionOrder(); // leaf
        f.parentId = a.id;
        f.id = 2;
        
        ProductionOrder c = new ProductionOrder();
        c.parentId = a.id;
        c.id = 3;
        
        ProductionOrder e = new ProductionOrder(); // leaf
        e.parentId = c.id;
        e.id = 4;
        
        ProductionOrder d = new ProductionOrder();
        d.id = 5;
        
        ProductionOrder b = new ProductionOrder(); // leaf
        b.parentId = d.id;
        b.id = 6;
        
        ProductionOrder g = new ProductionOrder(); // leaf
        g.id = 7;
        
        
        allOrders.add(a);
        allOrders.add(b);
        allOrders.add(c);
        allOrders.add(d);
        allOrders.add(e);
        allOrders.add(f);
        allOrders.add(g);

        Set<Integer> expResult = new HashSet<>(Arrays.asList(new Integer[]{f.id, e.id, b.id, g.id}));
        List<ProductionOrder> result = LeafProductFinder.findLeaves(allOrders);
        
        assertEquals("Return result mismatches with expected result counts", expResult.size(), result.size());
        
        
        for (ProductionOrder order : result) {
            assertTrue("Leaf : " + order + " must be in the list", expResult.contains(order.id));
        }
        
    }
    
}

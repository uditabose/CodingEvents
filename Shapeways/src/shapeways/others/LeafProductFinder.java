

package shapeways.others;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Udita
 */
public class LeafProductFinder {
    
    public static List<ProductionOrder> findLeaves(List<ProductionOrder> allOrders) {
        Map<Integer, ProductionOrder> leavesMap = new LinkedHashMap<>();
        
        for (ProductionOrder anOrder : allOrders) {
            leavesMap.put(anOrder.id, anOrder);
            if (leavesMap.containsKey(anOrder.parentId)) {
                // remove the parent
                leavesMap.remove(anOrder.parentId);
            }
        }
        
        for (ProductionOrder anOrder : allOrders) {
            if (leavesMap.containsKey(anOrder.parentId)) {
                // remove the parent
                leavesMap.remove(anOrder.parentId);
            }
        }

        return new ArrayList<>(leavesMap.values());
    }

}

package lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
public class MyLambda implements RequestHandler<Integer, Integer>{

    @Override
    public Integer handleRequest(Integer input, Context context){
    return input * 10;
    }
}

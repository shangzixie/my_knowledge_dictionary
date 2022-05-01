# Passing Data from Child to Parent

1. Create a callback function in the parent component. This callback function will get the data from the child component.
2. Pass the callback function in the parent as a prop to the child component.
3. The child component calls the parent callback function using props.

Let’s see how these steps are implemented using an example. You have two class components, Parent and Child. The Child component has a form that can be submitted in order to send its data up to the Parent component. It would look something like this:

```javascript

import React from 'react';

class Parent extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            data: null
        }
    }

    handleCallback = (childData) =>{
        this.setState({data: childData})
    }

    render(){
        const {data} = this.state;
        return(
            <div>
                <Child parentCallback = {this.handleCallback}/>
                {data}
            </div>
        )
    }
}

class Child extends React.Component{

    onTrigger = (event) => {
        this.props.parentCallback("Data from child");
        event.preventDefault();
    }

    render(){
        return(
        <div>
            <form onSubmit = {this.onTrigger}>
                <input type = "submit" value = "Submit"/>
            </form>
        </div>
        )
    }
}

export default Parent;
```
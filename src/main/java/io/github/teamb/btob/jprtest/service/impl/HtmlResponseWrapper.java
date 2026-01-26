package io.github.teamb.btob.jprtest.service.impl;

import java.io.PrintWriter;
import java.io.StringWriter;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

public class HtmlResponseWrapper extends HttpServletResponseWrapper {
   
	private final StringWriter sw = new StringWriter();

    public HtmlResponseWrapper(HttpServletResponse response) {
        super(response);
    }

    @Override
    public PrintWriter getWriter() {
        return new PrintWriter(sw);
    }

    @Override
    public String toString() {
        return sw.toString();
    }
}

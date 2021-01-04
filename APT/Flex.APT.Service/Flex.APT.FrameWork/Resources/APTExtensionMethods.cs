using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Text;

namespace Flex.APT.FrameWork.Resources
{
    public static class APTExtensionMethods
    {
        /// <summary>
        /// Get the source and execute predicate if predicate is passed then execute value.
        /// </summary>
        /// <typeparam name="T">Generic type of return</typeparam>
        /// <param name="source">Source to attach extention methods</param>
        /// <param name="predicate">predicate function.</param>
        /// <param name="then">action to execute when predicate is true.</param>
        /// <returns></returns>
        public static T When<T>(this T source, Func<bool> predicate, Action then)
        {
            if (predicate())
                then();
            return source;
        }
        public static T When<T>(this T source, Func<T, bool> predicate, Action then)
        {
            if (predicate(source))
                then();
            return source;
        }

        /// <summary>
        /// Get the source and execute predicate if predicate is passed then execute value.
        /// </summary>
        /// <typeparam name="T">Generic type of return</typeparam>
        /// <param name="source">Source to attach function.</param>
        /// <param name="predicate">Predicate which accept souce and do the validation.</param>
        /// <param name="then">execute action and pass source as a param.</param>
        /// <returns></returns>
        public static T When<T>(this T source, Func<T, bool> predicate, Action<T> then)
        {
            if (predicate(source))
                then(source);
            return source;
        }

        /// <summary>
        /// Get the source and execute predicate if predicate is passed then execute value.
        /// </summary>
        /// <typeparam name="T">Generic type of return</typeparam>
        /// <param name="source">Source to attach function.</param>
        /// <param name="predicate">Predicate which accept souce and do the validation.</param>
        /// <param name="then">execute action and pass source as a param.</param>
        /// <returns></returns>
        public static T When<T>(this T source, Func<bool> predicate, Action<T> then)
        {
            if (predicate())
                then(source);
            return source;
        }

        /// <summary>
        /// This is method chaining which do some actin and return the source which is attached.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="source"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public static T Do<T>(this T source, Action<T> action)
        {
            action(source);
            return source;
        }

        public static void ConvertBasedOnTimezone(string timeZone, out DateTimeOffset createdDate)
        {
            throw new NotImplementedException();
        }
    }

    public static class Disposable
    {
        /// <summary>
        /// Generic using function which used to reuse using.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="K"></typeparam>
        /// <param name="factory"></param>
        /// <param name="func"></param>
        /// <returns></returns>
        public static K Using<T, K>(Func<T> factory, Func<T, K> func) where T : IDisposable
        {
            using (T obj = factory())
            {
                return func(obj);
            }
        }
    }

    public static class ExpressionOperator
    {
        public static MemberExpression GetMemberExpression(Expression expression)
        {
            if (expression is MemberExpression)
            {
                return (MemberExpression)expression;
            }
            else if (expression is LambdaExpression)
            {
                var lambdaExpression = expression as LambdaExpression;
                if (lambdaExpression.Body is MemberExpression)
                {
                    return (MemberExpression)lambdaExpression.Body;
                }
                else if (lambdaExpression.Body is UnaryExpression)
                {
                    return ((MemberExpression)((UnaryExpression)lambdaExpression.Body).Operand);
                }
            }
            return null;
        }

        public static string GetPropertyPath(Expression expr)
        {
            var path = new StringBuilder();
            MemberExpression memberExpression = GetMemberExpression(expr);
            do
            {
                if (path.Length > 0)
                {
                    path.Insert(0, ".");
                }
                path.Insert(0, memberExpression.Member.Name);
                memberExpression = ExpressionOperator.GetMemberExpression(memberExpression.Expression);
            }
            while (memberExpression != null);
            return path.ToString();
        }
    }
    public static class Etensions
    {
        public static string GetPropertyPath<TObj, TRet>(this TObj obj, Expression<Func<TObj, TRet>> expr)
        {
            return ExpressionOperator.GetPropertyPath(expr);
        }
    }
}
